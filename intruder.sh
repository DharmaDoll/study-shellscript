

#POSTでjson bodyの場合はURLエンコードはいらない。
#Grepはどうやるの？
#ここまできたらpythonとかでもやりたいが、、 そしたらextenderでよくないかい？

secret=''
url='https://xxxxx.appspot.com/slack/events'
jsonbody='{"token":"@@XXYYZZ@@","team_id":"@@TXXXX@@","...snip...":0}'

PARAM_COUNT=$(grep -o '@@[^@]*@@' <(echo $jsonbody) | wc -l)
POS=1
OLDIFS=$IFS
IFS='
'

#bodyからsecretを元に署名を毎回付け直す
function send(){
    echo $1
    reqbody=$(gsed "s,@@\([^@]*\)@@,\1,g" <(echo $1))
    timestamp=`date +%s`
    signature=$(echo -n "v0:$timestamp:$reqbody" | openssl dgst -sha256 -hmac "$secret" -binary | xxd -p -c256)
    echo $signature
    curl -x http://127.0.0.1:8080 -X POST -H "Content-Type: application/json" -H "X-Slack-Signature: v0=$signature" -H "X-Slack-Request-Timestamp: $timestamp" -d "$reqbody" "$url"
}


echo HIT! $PARAM_COUNT
for v in `seq 1 $PARAM_COUNT`
do
    while read p
    do
        sleep 1
        echo "position $p"
        echo POS $POS
        send $(gsed "s,@@[^@]*@@,$p,$POS" <(echo $jsonbody))
    done < $1
    
    POS=$(( POS + 1 ))
done

IFS=$OLDIFS

