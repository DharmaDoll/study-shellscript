#!/bin/bash

#################################
#別ファイルにして呼び出すと便利
curl -s \
    -x http://127.0.0.1:8080 \
     -X POST "$BASE_URL/connect/1.0.0/api/token" \
     -d 'grant_type=client_credentials' \
     -H "Authorization:Basic $(echo -n $CLIENT_ID:$CLIENT_SECRET | base64)" \
     -H "Content-Type:application/x-www-form-urlencoded" \
| jq -r -M '.access_token'

#################################
function buildCmd(){
curlcmd="curl -s\
    -x http://127.0.0.1:8080 \
    -X GET \
    -H \"Authorization: Bearer ${token}\" \
    -H 'Content-Type: application/json' \
    -H \"X-Domain: ${DOMAIN}\" \
    ${BASE_API_URL}/2.0.0/users/$1"
    # --data '$json' \
echo $curlcmd
response=`eval $curlcmd`
echo $response | jq -M '.'
}

echo "======= Get children collections ======="
buildCmd "${CHILD_ID}/children"
...
#################################
#!/bin/bash
set -e

if [ -z "$USER_ID" ]; then echo set \$USER_ID; exit 1; fi

token=`./get_access_token`
# delivers_at=`expr $(date +%s) + 3600`

createMessage(){

json=$(cat << EOS
{
  "clientId": "${CLIENT_ID}",
  "sender": {
    "id": "${CLIENT_ID}",
    "type": "client"
  },
  "recipients": {
    "variables": {
      "userIds": [
        "${USER_ID}"
      ]
    },
    "type": "user"
  },
  "title": {
    "en-US": "test"
  },
  "event": "",
  "variables": {
    "en-US": {
      "global": {
        "template": "icon",
        "iconUrl": "https://lh3.googleusercontent.com/xxxxxx"
      }
    }
  },
  "testMode": true
}
EOS
)

    curl -s \
        -x http://127.0.0.1:8080 \
        -X POST \
        -H "Authorization: Bearer ${token}" \
        -H 'Content-Type: application/json' \
        -H "locked-Domain: ${LOCKED_DOMAIN}" \
        --data "${json}" \
        ${APP_URL}/notice/v1/messages/${CLIENT_ID}
}


echo "======= GET User notice Message ======="
curlcmd="curl -s \
    -x http://127.0.0.1:8080 \
    -X GET \
    -H \"Authorization: Bearer $token\" \
    -H \"locked-Domain: ${LOCKED_DOMAIN}\" \
    ${APP_URL}/notice/v1/users/${USER_ID}/messages?count=1"
response=`eval $curlcmd`
echo $response | jq -M '.'


echo "======= POST notice Message ======="
message_id=$(createMessage | jq -M -r '.id')
echo "message id: $message_id"


echo "======= PATCH User notice Message ======="
json=$(cat << EOS
[{"op": "replace", "path": "/status", "value": "READ"}]
EOS
)
echo $json | jsonlint > /dev/null || exit

curlcmd="curl -s \
    -x http://127.0.0.1:8080 \
    -X PATCH \
    -H \"Authorization: Bearer $token\" \
    -H \"locked-Domain: ${LOCKED_DOMAIN}\" \
    -H 'Content-Type:  application/json-patch+json' \
    --data '$json' \
    ${APP_URL}/notice/v1/users/${USER_ID}/messages/${message_id}"
response=`eval $curlcmd`
echo $response | jq -M '.'



EOF..


以下
# variavle
# private func
# public func
# main flow
の順

#!/bin/sh -ue
###########################################################
#  variable                                               *
###########################################################
OPT_FLAG_u=false
OPT_FLAG_p=false
OPT_FLAG_c=false
BASE_URL='https://example.com/rest/api'
OPT_VALUE_c=''
###########################################################
#  private function                                       *
###########################################################

# 必須オプションが指定されていない場合
function _usage() {
  echo "usage:"
  echo "${0} -u USER -p PASS -c CMD {...}"
  exit 1
}

# 必須オプションが指定されていない場合
function _status_code_check() {
  status_code=$1

  if [ "$status_code" != "200" -a "$status_code" != "204" ]; then
    echo "[Failure] command: $OPT_VALUE_c, STATUS_CODE=$status_code"
    exit 1
  fi
}

function _urlencode() {
  input=$1

  encode=`/bin/echo -n "$input" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g'`

  echo $encode
}
# user と pass を base64 でエンコード
function _encode_user_pass_by_base64() {
  user="$1"
  pass="$2"

  # Mac の場合 echo では n のオプションが有効にならないため /bin/echo を指定
  encode_user_pass=`/bin/echo -n "$user:$pass" | base64`

  echo $encode_user_pass
}

# create用の json データの作成
function _create_create_json_data() {
  page_title="$1"
  page_text="$2"
  ancestor="$3"
  space="$4"

  payload="
    {
      \"type\":\"page\",
      \"title\":\"$page_title\",
      \"ancestors\":[
        {
          \"id\":\"$ancestor\"
        }
      ],
      \"space\":{
        \"key\":\"$space\"
      },
      \"body\":{
        \"storage\":{
          \"value\" : \"$page_text\",
          \"representation\":\"storage\"
        }
      }
    }"

  echo $payload
}

# titleからコンテンツのIDを取得する
# titleはURLエンコードしたものを与える
function _get_content_id() {
  user_pass="$1"
  space=`_urlencode "$2"`
  title=`_urlencode "$3"`

  response=`curl -sS "$BASE_URL/content?spaceKey=$space&type=page&title=$title" \
    -H "content-type: application/json" \
    -H "Authorization:Basic $user_pass"`

#  echo $response
  echo `echo "$response" | jq -r '.results[0].id'`
}




###########################################################
#  public function                                        *
###########################################################

# 指定したIDのコンテンツ情報を取得する
function get_content() {
  user_pass="$1"
  space="$2"
  title="$3"

  c_id=`_get_content_id "$user_pass" "$space" "$title"`

  response=`curl -sS $BASE_URL/content/$c_id \
    -H "content-type: application/json" \
    -H "Authorization:Basic $user_pass"`

  echo $response
}

# 指定したコンテンツを作成する
function create_content() {
  user_pass="$1"
  space="$2"
  ancestor="$3"
  title="$4"
  contents="$5"

  ancestor_id=`_get_content_id "$user_pass" "$space" "$ancestor"`

  payload=`_create_create_json_data "$title" "$contents" "$ancestor_id" "$space"`

  response=`curl -sS $BASE_URL/content \
    -H "content-type: application/json" \
    -H "Authorization:Basic $user_pass" \
    -d "$payload" \
    -X POST \
    -o /dev/null -w "%{http_code}\n"`

  echo $response
}

# 指定したIDのコンテンツを削除する
function delete_content() {
  user_pass="$1"
  space="$2"
  title="$3"

  c_id=`_get_content_id "$user_pass" "$space" "$title"`

  response=`curl -sS $BASE_URL/content/$c_id \
    -H "content-type: application/json" \
    -H "Authorization:Basic $user_pass" \
    -X DELETE \
    -o /dev/null -w "%{http_code}\n"`

  echo $response
}

# 指定したIDのコンテンツを更新する
function update_content() {
  user_pass="$1"
  space="$2"
  ancestor="$3"
  title="$4"
  contents="$5"

  ancestor_id=`_get_content_id "$user_pass" "$space" "$ancestor"`
  c_id=`_get_content_id "$user_pass" "$space" "$title"`

  # 存在するコンテンツのバージョン番号を取得して +1 した値を更新値に用いる
  content_info=`get_content "$user_pass" "$space" "$title"`
  old_version=`echo $content_info | jq -r '.version.number'`
  version=`expr $old_version + 1`

  payload=`_create_update_json_data "$title" "$contents" "$ancestor_id" "$space" "$version"`

  response=`curl -sS $BASE_URL/content/$c_id \
    -H "content-type: application/json" \
    -H "Authorization:Basic $user_pass" \
    -d "$payload" \
    -X PUT \
    -o /dev/null -w "%{http_code}\n"`

  echo $response
}




###########################################################
#  main function                                          *
###########################################################

# オプション引数を指定
while getopts ":u:p:c:" OPT
do
  case $OPT in
    u) OPT_FLAG_u=true; OPT_VALUE_u=$OPTARG;;
    p) OPT_FLAG_p=true; OPT_VALUE_p=$OPTARG;;
    c) OPT_FLAG_c=true; OPT_VALUE_c=$OPTARG;;
    :) echo "[ERROR] Option argument is undefined.";;
    \?) echo "[ERROR] Undefined options.";;
  esac
done

# 引数分シフト
shift $(($OPTIND - 1))

# 必須チェック
[ ! $OPT_FLAG_u ] && _usage
[ ! $OPT_FLAG_p ] && _usage
[ ! $OPT_FLAG_c ] && _usage

# user と pass を user:pass の形式でbase64エンコード
ENCODE_USER_PASS=`_encode_user_pass_by_base64 ${OPT_VALUE_u} ${OPT_VALUE_p}`

# オプションの解析結果を表示
case $OPT_VALUE_c in
  "get")
    # user:pass space title
    RESPONSE=`get_content $ENCODE_USER_PASS "$1" "$2"`
    ;;
  "create")
    # update user:pass space ancestor title contents
    STATUS_CODE=`create_content $ENCODE_USER_PASS "$1" "$2" "$3" "$4"`
    _status_code_check $STATUS_CODE
    ;;
  "delete")
    # delete user:pass space title
    STATUS_CODE=`delete_content $ENCODE_USER_PASS "$1" "$2"`
    _status_code_check $STATUS_CODE
    ;;
  "update")
    # update user:pass space ancestor title contents
    STATUS_CODE=`update_content $ENCODE_USER_PASS "$1" "$2" "$3" "$4"`
    _status_code_check $STATUS_CODE
    ;;
  :)
    echo "[ERROR] command argument is undefined."
    exit 1
    ;;
  \?)
    echo "[ERROR] Undefined command."
    exit 1
    ;;
esac

# get の場合は取得した情報を出力
[ "$OPT_VALUE_c" = "get" ] && echo $RESPONSE
echo "[Success] command: $OPT_VALUE_c"

exit 0
