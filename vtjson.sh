これもある。Python。
https://github.com/doomedraven/VirusTotalApi


VirusTotalは、curlを使用してサービスとのインターフェースに使用できるAPIを提供します。  APIを使用するには、一意のAPIキーが必要です。 キーを取得するには、VirusTotalのWebサイトにアクセスして、アカウントをリクエストしてください。 アカウントを作成したら、ログインしてアカウント設定に移動し、APIキーを表示します。 セキュリティ上の理由により、本書の例では実際のAPIキーは使用されません。 代わりに、APIキーを置き換える必要がある場合は、テキストreplacewithapikeyを使用します。

As an example, we will use a sample of the WannaCry malware, which has an MD5 hash of db349b97c37d22f5ea1d1841e3c89eb4:

curl 'https://www.virustotal.com/vtapi/v2/file/report?apikey=replacewithapikey&
resource=db349b97c37d22f5ea1d1841e3c89eb4&allinfo=false > WannaCry_VirusTotal.txt

結果のJSON応答には、ファイルが実行されたすべてのウイルス対策エンジンのリストと、ファイルが悪意のあるものとして検出されたかどうかの判断が含まれます。 ここでは、最初の2つのエンジン、BkavとMicroWorld-eScanからの応答を確認できます。
"scans":
  {"Bkav":
    {"detected": true,
     "version": "1.3.0.9466",
     "result": "W32.WannaCrypLTE.Trojan",
     "update": "20180712"},
   "MicroWorld-eScan":
    {"detected": true,
     "version": "14.0.297.0",
     "result": "Trojan.Ransom.WannaCryptor.H",
     "update": "20180712"}
      ...

$ grep -Po '{"detected": true.*?"result":.*?,' Calc_VirusTotal.txt

{"detected": true, "version": "1.3.0.9466", "result": "W32.WannaCrypLTE.Trojan",
{"detected": true, "version": "14.0.297.0", "result": "Trojan.Ransom.WannaCryptor.H",
{"detected": true, "version": "14.00", "result": "Trojan.Mauvaise.SL1",

grepの-Pオプションは、Perlエンジンを有効にするために使用されます。これにより、パターン。*？を使用できます。 遅延量指定子として。 この遅延量指定子は、正規表現全体を満たすために必要な最小文字数のみに一致するため、大きな塊ではなく、各ウイルス対策エンジンから個別に応答を抽出できます。

 この方法は機能しますが、例11-2に示すように、bashスクリプトを使用してはるかに優れたソリューションを作成できます。


#!/bin/bash -
#
# Rapid Cybersecurity Ops
# vtjson.sh
#
# Description:
# Search a JSON file for VirusTotal malware hits
#
# Usage:
# vtjson.awk [<json file>]
#   <json file> File containing results from VirusTotal
#               default: Calc_VirusTotal.txt
#

RE='^.(.*)...\{.*detect..(.*),..vers.*result....(.*).,..update.*$'     1

FN="${1:-Calc_VirusTotal.txt}"
sed -e 's/{"scans": {/&\n /' -e 's/},/&\n/g' "$FN" |           2
while read ALINE
do
    if [[ $ALINE =~ $RE ]]                                     3
    then
	VIRUS="${BASH_REMATCH[1]}"                                    4
	FOUND="${BASH_REMATCH[2]}"
	RESLT="${BASH_REMATCH[3]}"
	if [[ $FOUND =~ .*true.* ]]                                   5
	then
	    echo $VIRUS "- result:" $RESLT
	fi
    fi
done



Example 11-3. vtjson.awk
# Cybersecurity Ops with bash
# vtjson.awk
#
# Description:
# Search a JSON file for VirusTotal malware hits
#
# Usage:
# vtjson.awk <json file>
#   <json file> File containing results from VirusTotal
#

FN="${1:-Calc_VirusTotal.txt}"
sed -e 's/{"scans": {/&\n /' -e 's/},/&\n/g' "$FN" |     1
awk '
NF == 9 {                                       2
    COMMA=","
    QUOTE="\""                                  3
    if ( $3 == "true" COMMA ) {                 4
        VIRUS=$1                                5
        gsub(QUOTE, "", VIRUS)                  6

        RESLT=$7
        gsub(QUOTE, "", RESLT)
        gsub(COMMA, "", RESLT)

        print VIRUS, "- result:", RESLT
    }
}'

新しいファイルをVirusTotalにアップロードして、それらに関する情報がデータベースに存在しない場合に分析することができます。 これを行うには、URL https://www.virustotal.com/vtapi/v2/file/scanへのHTML POSTリクエストを使用する必要があります。  APIキーとアップロードするファイルへのパスも指定する必要があります。 以下は、通常c：\ Windows \ System32ディレクトリにあるWindows calc.exeファイルを使用した例です。

curl --request POST --url 'https:&#x002F;/www.virustotal.com/vtapi/v2/file/scan'
--form 'apikey=replacewithapikey' --form 'file=@/c/Windows/System32/calc.exe'


When uploading a file, you do not receive the results immediately. What is returned is a JSON object, such as the following, that contains metadata on the file that can be used to later retrieve a report using the scan ID or one of the hash values:

{
"scan_id": "5543a258a819524b477dac619efa82b7f42822e3f446c9709fadc25fdff94226-1...",
"sha1": "7ffebfee4b3c05a0a8731e859bf20ebb0b98b5fa",
"resource": "5543a258a819524b477dac619efa82b7f42822e3f446c9709fadc25fdff94226",
"response_code": 1,
"sha256": "5543a258a819524b477dac619efa82b7f42822e3f446c9709fadc25fdff94226",
"permalink": "https://www.virustotal.com/file/5543a258a819524b477dac619efa82b7...",
"md5": "d82c445e3d484f31cd2638a4338e5fd9",
"verbose_msg": "Scan request successfully queued, come back later for the report"
}

Here is an example of requesting a scan report on a URL:

curl 'https://www.virustotal.com/vtapi/v2/url/report?apikey=replacewithapikey
&resource=www.oreilly.com&allinfo=false&scan=1'
パラメータscan = 1は、データベースにまだ存在しない場合、分析のためにURLを自動的に送信します。

The command line alone cannot provide the same level of capability as full-fledged reverse-engineering tools, but it can be quite powerful for inspecting an executable or file. Remember to analyze suspected malware only on systems that are disconnected from the network, and be cognizant of confidentiality issues that may arise if you upload files to VirusTotal or other similar services.

