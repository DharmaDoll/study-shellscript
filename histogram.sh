
#!/bin/bash -
#
# Cybersecurity Ops with bash
# histogram.sh
#
# Description:
# Generate a horizontal bar chart of specified data
#
# Usage: ./histogram.sh
#   input format: label value
#

function pr_bar ()                            1
{
    local -i i raw maxraw scaled              2
    raw=$1
    maxraw=$2
    ((scaled=(MAXBAR*raw)/maxraw))            3
    # min size guarantee
    ((raw > 0 && scaled == 0)) && scaled=1    4

    for((i=0; i<scaled; i++)) ; do printf '#' ; done
    printf '\n'

} # pr_bar

#
# "main"
#
declare -A RA						5
declare -i MAXBAR max
max=0
MAXBAR=50	# how large the largest bar should be

while read labl val
do
    let RA[$labl]=$val					6
    # keep the largest value; for scaling
    (( val > max )) && max=$val
done

# scale and print it
for labl in "${!RA[@]}"					7
do
    printf '%-20.20s  ' "$labl"
    pr_bar ${RA[$labl]} $max				8
done



1
We define a function to draw a single bar of the histogram. This definition must be encountered before a call to the function can be made, so it makes sense to put function definitions at the front of our script. We will be reusing this function in a future script, so we could have put it in a separate file and included it here with a source command—but we didn’t.

2
We declare all these variables as local because we don’t want them to interfere with variable names in the rest of this script (or any others, if we copy/paste this script to use elsewhere). We declare all these variables as integers (that’s the -i option) because we are going to only compute values with them and not use them as strings.

3
The computation is done inside double parentheses. Inside those, we don’t need to use the $ to indicate “the value of” each variable name.

4
This is an “if-less” if statement. If the expression inside the double parentheses is true, then, and only then, is the second expression (the assignment) executed. This will guarantee that scaled is never zero when the raw value is nonzero. Why? Because we’d like something to show up in that case.

5
The main part of the script begins with a declaration of the RA array as an associative array.

6
Here we reference the associative array by using the label, a string, as its index.

7
Because the array is not indexed by numbers, we can’t just count integers and use them as indices. This construct gives all the various strings that were used as an index to the array, one at a time, in the for loop.

8
We use the label as an index one more time to get the count and pass it as the first parameter to our pr_bar function.




こっちだと順序よく表示される。

このバージョンのスクリプトは、macOSシステムなどの古いバージョンのbash（4.xより前）を実行している場合に、連想配列の使用を回避します。 このバージョンでは、2つの個別の配列を使用します。1つはインデックス値用、もう1つはカウント用です。 これらは通常の配列なので、整数のインデックスを使用する必要があるため、変数ndxに単純なカウントを保持します。

histogram_plain.sh
#!/bin/bash -
#
# Cybersecurity Ops with bash
# histogram_plain.sh
#
# Description:
# Generate a horizontal bar chart of specified data without
# using associative arrays, good for older versions of bash
#
# Usage: ./histogram_plain.sh
#   input format: label value
#

declare -a RA_key RA_val                                 1
declare -i max ndx
max=0
maxbar=50    # how large the largest bar should be

ndx=0
while read labl val
do
    RA_key[$ndx]=$labl                                   2
    RA_value[$ndx]=$val
    # keep the largest value; for scaling
    (( val > max )) && max=$val
    let ndx++
done

# scale and print it
for ((j=0; j<ndx; j++))                                  3
do
    printf "%-20.20s  " ${RA_key[$j]}
    pr_bar ${RA_value[$j]} $max
done


1
Here the variable names are declared as arrays. The lowercase a says that they are arrays, but not of the associative variety. While not strictly necessary, this is good practice. Similarly, on the next line we use the -i to declare these variables as integers, making them more efficient than undeclared shell variables (which are stored as strings). Again, this is not strictly necessary, as seen by the fact that we don’t declare maxbar but just use it.

2
The key and value pairs are stored in separate arrays, but at the same index location. This approach is “brittle”—that is, easily broken, if changes to the script ever got the two arrays out of sync.

3
Now the for loop, unlike the previous script, is a simple counting of an integer from 0 to ndx. The variable j is used here so as not to interfere with the index in the for loop inside pr_bar, although we were careful enough inside the function to declare its version of i as local to the function. Do you trust it? Change the j to an i here and see if it still works (it does). Then try removing the local declaration and see if it fails (it does).



$ cut -d' ' -f1,10 access.log | bash summer.sh | bash histogram.sh

192.168.0.36          ##################################################
192.168.0.37          #############################
192.168.0.11          #############################
192.168.0.14          ################################
192.168.0.26          #######

$ cut -d' ' -f4,10 access.log | cut -c2-

12/Nov/2017:15:52:59 2377
12/Nov/2017:15:52:59 4529
12/Nov/2017:15:52:59 1112


histogram.shスクリプトは、時間ベースのデータを調べるときに特に役立ちます。 たとえば、組織に社内Webサーバーがあり、稼働時間の午前9時のみにアクセスする場合です。 午後5時までは、ヒストグラムビューを介してサーバーログファイルを毎日確認し、アクティビティの急上昇が通常の勤務時間外に発生しているかどうかを確認できます。 通常の業務時間外にアクティビティまたはデータ転送が大幅に急上昇した場合は、悪意のある人物による窃盗を示している可能性があります。 異常が検出された場合は、特定の日時でデータをフィルタリングし、ページアクセスを確認して、アクティビティが悪意のあるものかどうかを判断できます。

 たとえば、特定の日と1時間ごとに取得されたデータの総量のヒストグラムを表示するには、次のようにします。

$ awk '$4 ~ "12/Nov/2017" {print $0}' access.log | cut -d' ' -f4,10 |
cut -c14-15,22- | bash summer.sh | bash histogram.sh

17              ##
16              ###########
15              ############
19              ##
18              ##################################################




