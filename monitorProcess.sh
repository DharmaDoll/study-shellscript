#!/bin/bash

#プロセスを監視し動いてなければ起動させる。cronで本スクリプトを登録しとく前提運用。UNIXエンジニア書籍も参照
#* * * * * ./monitorProcess 監視するものにもよるが５分に一回くらい？
procname="sample.py"
count=$(ps aux | grep $procname | grep -v grep | wc -l)
startPG="id"
# startPG="ruby sample.py | tee -a scraping.log"

echo $count
echo $procname

if [ "$count" -eq 0 ]; then
    echo `date '+%Y%m%d/%H:%M'` "No proccess.I starting process" | tee -a moni.log
    $startPG
else
    echo `date '+%Y%m%d/%H:%M'` "alieve! あった" | tee -a moni.log
fi


#WiFiの状態を監視し、切れてばつなぎに行く
#########################################
echo 'sleepします.Please Stop me!'
sleep 100000
#!/bin/bash
isEnableWifi=$(/usr/sbin/networksetup -getairportpower en0 | grep 'Wi-Fi Power (en0): On' | wc -l)
startWifi="/usr/sbin/networksetup -setairportpower en0 on"
connectSsid="/usr/sbin/networksetup -setairportnetwork en0 MYSSID password"
#1:on 0:off
if [ "$isEnableWifi" -eq 0 ]; then
    echo `date '+%Y%m%d/%H:%M'` "Your Wifi is die.. you wake up by `basename $0` script"
    $startWifi
    sleep 10
    $connectSsid
else
    echo `date '+%Y%m%d/%H:%M'` "You alive Wifi"
fi