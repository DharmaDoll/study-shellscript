bash_log.sh
#!/bin/bash -
readonly LOGFILE="/tmp/${0##*/}.log"

readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo -e "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" | tee -a ${LOGFILE}
}


#
# MAIN
#

log "This is test message 1"
log "Test 2"
log "Test 3"

function logtest() {
  log "test from logtest function"
}

logtest

#######################################
# 多分 引数は自動で入ってきてくれるぽいのかな
#log script 
mylogger(){
    local logfile scriptname timestamp label mode
    scriptname="$( /usr/bin/basename "$0" )"
    logfile="/tmp/${scriptname}.log"
    timestamp="$( date "+%F %T" )"
    mode="$2"
    case "${mode:-1}" in
        2 )
            label="[error]"
            echo "$timestamp $scriptname $label $1" | /usr/bin/tee -a "$logfile" >&2
            ;;
        * )
            label="[info]"
            echo "$timestamp $scriptname $label $1" | /usr/bin/tee -a "$logfile"
            ;;
    esac
}

ttyname=$2;     mylogger "The tty device iftty: $ttyname"
speed=$3;       mylogger "The tty device speed: $speed"
localip=$4;     mylogger "The local IP address for the interface: $localip"
remoteip=$5;    mylogger "The remote IP address: ${remoteip:=failed}"
ipparam=$6;     mylogger "The current IP address before connecting to the VPN: ${ipparam:=failed}"

# 2021-01-25 10:53:44 superScript [info] The tty device iftty: 
# 2021-01-25 10:53:44 superScript [info] The tty device speed: 0
# 2021-01-25 10:53:44 superScript [info] The remote IP address: 169.254.111.170
# 2021-01-25 10:53:44 superScript [info] Connected to Company via VPN
# 2021-01-25 10:53:44 superScript [info] Use VPN route for google.
# 2021-01-25 10:53:45 superScript [info] Done
######################################
start_tcpdump (){
  mkdir -p ./tcpdump
  sudo tcpdump -C 50 -w ./tcpdump/log_`date +%Y%m%d-%H%M%S`.pcap &
  #PID的なの取得して終わるときにkillする　trapとかかな
}
#tsharkでlogとる. 途中
tshark -i 1 -w 20190517_xx.pcap -b filesize:100000 -f 'host 54.00.00.00 or host 172.23.00.00' &

######################################
#Log checker 特定のファイルの特定の文字列を検出
https://qiita.com/Qrg/items/107928672569a8141222

logchecker.sh
#!/bin/sh
# 検出対象ログファイル
TARGET_LOG="/var/log/messages"

# 検出文字列
_error_conditions="error hogehoge"

# ログファイルを監視する関数
hit_action() {
    while read i
    do
        echo $i | grep -q "${_error_conditions}"
        if [ $? = "0" ];then
            # アクション
            touch /tmp/hogedetayo
        fi
    done
}

# main
if [ ! -f ${TARGET_LOG} ]; then
    touch ${TARGET_LOG}
fi

tail -n 0 --follow=name --retry $TARGET_LOG | hit_action
