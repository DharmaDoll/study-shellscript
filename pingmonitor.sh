#pingプロトコルはネットワークまたはホストのファイアウォールでブロックされる場合があり、信頼できない場合があることに注意してください。  pingが1回ドロップしても、デバイスがダウンしているとは限りません。  pingの代わりに、デバイスへのTCP接続を作成して、デバイスが応答するかどうかを確認することもできます。 これは、システムがTCPポートが開いていることがわかっているサーバーであることがわかっている場合に特に役立ちます。

#!/bin/bash -
#
# Cybersecurity Ops with bash
# pingmonitor.sh
#
# Description:
# Use ping to monitor host availability
#
# Usage:
# pingmonitor.sh <file> <seconds>
#   <file> File containing a list of hosts
#   <seconds> Number of seconds between pings
#

while true
do
 clear
 echo 'Cybersecurity Ops System Monitor'
 echo 'Status: Scanning ...'
 echo '-----------------------------------------'
 while read -r ipadd
 do
  ipadd=$(echo "$ipadd" | sed 's/\r//') 
  ping -n 1 "$ipadd" | egrep '(Destination host unreachable|100%)' &> /dev/null 
  if (( "$?" == 0 ))   #エラーが検出されたら知らせる
  then
   tput setaf 1	
   echo "Host $ipadd not found - $(date)" | tee -a monitorlog.txt
   tput setaf 7
  fi
 done < "$1"

 echo ""
 echo "Done."

 for ((i="$2"; i > 0; i--))   #次のスキャンが始まるまでのカウントダウン
 do
  tput cup 1 0   #カーソル行を移動
  echo "Status: Next scan in $i seconds"
  sleep 1
 done
done




# 以下はunixシェルスクリプトのサンプル
#! /bin/bash

#Ping check/ping呼んで結果により処理分岐してるだけ
#3回連続で失敗した場合NG（間隔：3秒待ってからpingを打つ）

monitorPing(){
result=1
host=$1

echo "$host"

i=0
while [ $i -lt 3 ]
  do
    ping -c 1 "$host" > /dev/null
    if [ $? -eq 0 ];then
      result=0
      break
    else
      sleep 3
      i=$($i + 1)
      # i=$(expr $i + 1)
    fi
 done

#Failer case
if [ $result -ne 0 ];then
 echo "$d ping NG:host"
else
 echo "$d ping OK:host"
fi
}


#Arg check
if [ $# == 1 ];then
  if [ -z "$1" ];then
    echo "Please specify host" >&2
    exit 1
  fi
else
  echo "Usage $(basename $0) <host>"
  exit
fi

monitorPing $1

