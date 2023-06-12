#ベースラインを作成し、ベースラインの変更を定期的にチェックすることは、システムの疑わしい動作を識別する効果的な方法です。 これは、頻繁に変更されないシステムで特に役立ちます

#Baselining the Filesystem
SYSNAME="$(uname -n)_$(date +'%m_%d_%Y')" ; sudo find / -type f |
xargs -d '\n' sha1sum  > ${SYSNAME}_baseline.txt 2>${SYSNAME}_error.txt

#Detecting Changes to the Baseline
sha1sum -c --quiet baseline.txt

sha1sum: /home/dave/file1.txt: No such file or directory 1
/home/dave/file1.txt: FAILED open or read 2
/home/dave/file2.txt: FAILED 3
sha1sum: WARNING: 1 listed file could not be read
sha1sum: WARNING: 2 computed checksums did NOT match


#これだけだと新規ファイル作成は検知出来ない。ので、

find / -type f > filelist.txt

#して

#以下をやれば検出可能

join -1 1 -2 2 -a 1 <(sort filelist.txt) <(sort -k2 baseline.txt) |
awk '{if($2=="") print $1}'

/home/dave/file4.txt
/home/dave/filelist.txt

or

cut -c43- ../baseline.txt | sdiff -s -w60 - ../filelist.txt

                        >	./prairie.sh
./why dot why           |	./ex dot ex
./x.x			                <






#これらを自動化すると、

#baseline.sh

#!/bin/bash -
#
# Cybersecurity Ops with bash
# baseline.sh
#
# Description:
# Creates a file system baseline or compares current
# file system to previous baseline
#
# Usage: ./baseline.sh [-d path] <file1> [<file2>]
#   -d Starting directory for baseline
#   <file1> If only 1 file specified a new baseline is created
#   [<file2>] Previous baseline file to compare
#

function usageErr ()
{
    echo 'usage: baseline.sh [-d path] file1 [file2]'
    echo 'creates or compares a baseline from path'
    echo 'default for path is /'
    exit 2
} >&2                                                          1

function dosumming ()
{
    find "${DIR[@]}" -type f | xargs -d '\n' sha1sum           2
}

function parseArgs ()
{
    while getopts "d:" MYOPT                                   3
    do
	# no check for MYOPT since there is only one choice
	DIR+=( "$OPTARG" )                                     4
    done
    shift $((OPTIND-1))                                        5

    # no arguments? too many?
    (( $# == 0 || $# > 2 )) &&  usageErr

    (( ${#DIR[*]} == 0 )) && DIR=( "/" )                       6

}

declare -a DIR

# create either a baseline (only 1 filename provided)
# or a secondary summary (when two filenames are provided)

parseArgs
BASE="$1"
B2ND="$2"

if (( $# == 1 ))    # only 1 arg.
then
    # creating "$BASE"
    dosumming > "$BASE"
    # all done for baseline
    exit
fi

if [[ ! -r "$BASE" ]]
then
    usageErr
fi



# if 2nd file exists just compare the two
# else create/fill it
if [[ ! -e "$B2ND" ]]
then
    echo creating "$B2ND"
    dosumming > "$B2ND"
fi

# now we have: 2 files created by sha1sum
declare -A BYPATH BYHASH INUSE 	# assoc. arrays

# load up the first file as the baseline
while read HNUM FN
do
    BYPATH["$FN"]=$HNUM
    BYHASH[$HNUM]="$FN"
    INUSE["$FN"]="X"
done < "$BASE"

# ------ now begin the output
# see if each filename listed in the 2nd file is in
# the same place (path) as in the 1st (the baseline)

printf '<filesystem host="%s" dir="%s">\n' "$HOSTNAME"  "${DIR[*]}"

while read HNUM FN					7
do
    WASHASH="${BYPATH[${FN}]}"
    # did it find one? if not, it will be null
    if [[ -z $WASHASH ]]
    then
	ALTFN="${BYHASH[$HNUM]}"
	if [[ -z $ALTFN ]]
	then
	    printf '  <new>%s</new>\n' "$FN"
	else
	    printf '  <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN"
	    INUSE["$ALTFN"]='_'	# mark this as seen
	fi
    else
	INUSE["$FN"]='_'	# mark this as seen
	if [[ $HNUM == $WASHASH ]]
	then
	    continue;		# nothing changed;
	else
	    printf '  <changed>%s</changed>\n' "$FN"
	fi
    fi
done < "$B2ND"                                          8

for FN in "${!INUSE[@]}"
do
    if [[ "${INUSE[$FN]}" == 'X' ]]
    then
        printf '  <removed>%s</removed>\n' "$FN"
    fi
done

printf '</filesystem>\n'
