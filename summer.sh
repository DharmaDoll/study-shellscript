
#!/bin/bash -
#
# Cybersecurity Ops with bash
# summer.sh
#
# Description:
# Sum the total of field 2 values for each unique field 1
#
# Usage: ./summer.sh
#   input format: <name> <number>
#

declare -A cnt        # assoc. array
while IFS= read id count
do
  let cnt[$id]+=$count
done
for id in "${!cnt[@]}"
do
    printf "%-15s %8d\n"  "${id}"  "${cnt[${id}]}" 1
done

######
$ cut -d' ' -f1,10 access.log | bash summer.sh | sort -k 2.1 -rn

192.168.0.36     4371198
192.168.0.37     2575030
192.168.0.11     2537662
192.168.0.14     2876088
192.168.0.26      665693
