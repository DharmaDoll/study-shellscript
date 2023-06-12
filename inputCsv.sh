
if [ $# -ne 1 ];then
    echo Usage '$ ./inputCsv.sh [csvfile.csv]'
    # exit
fi
#ほんとはここにファイル名指定
#csvfile=$1


こっちのほうが簡潔にかける
while IFS=, read ip pass city
do
  echo "$ip => $pass"
done < `cat ${csvfile} | grep -v ^#`


#間にスペースとか入るとうまくいかないぽい
#↑その場合こうすればいける
OLDIFS=$IFS
IFS='
'
# 最後に IFS=$OLDIFSで戻しとく

(
echo 10.0.0.1,p@ss,osaka
echo 10.0.0.2,administrator,tokyo
echo 192.168.22.1,himitu,polonnaruva
) > tmpppppp.csv

csvfile=tmpppppp.csv

cat $csvfile;echo -e "\r"
sleep 3
for line in `cat ${csvfile} | grep -v ^#`
do
  first=`echo ${line} | cut -d ',' -f 1`
  second=`echo ${line} | cut -d ',' -f 2`
  third=`echo ${line} | cut -d ',' -f 3`

  echo "1区切り目は:${first}"
  echo "2区切り目は:${second}"
  echo "3区切り目は:${third}"
  echo "----行終わりっ！-------"
done

rm tmpppppp.csv

#######################################
filename="a.tsv"
for nw in `cat ${filename} | awk '{print $1}' | grep -v '#'`
do
    echo $nw
    nwaddress=${nw%/*}
    mask=${nw#*/}
    sudo nmap -sn -v ${nw} --scan-delay 10 --max-rtt-timeout 0.1 --max-retries 1 >> dc_${nwaddress}_${mask}_PingScan.txt
    echo "$nw done"
    # sleep 6000
done

echo "all done"
