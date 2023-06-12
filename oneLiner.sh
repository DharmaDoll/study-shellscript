#!/bin/bash


############ファイル/dir削除 特定の語句が含まれるフォルダ/ファイルをスクリプトで消す
#This script removes Mono from an OS X System.  It must be run as root
 rm -r /Library/Frameworks/Mono.framework
 rm -r /Library/Receipts/MonoFramework-*

 for dir in /usr/bin /usr/share/man/man1 /usr/share/man/man3 /usr/share/man/man5; do
   (cd ${dir};
    for i in `ls -al | grep /Library/Frameworks/Mono.framework/ | awk '{print $9}'`; do
      rm ${i}
    done);
 done
 ######################


##### Web server by Shell #####
RESPONSE="HTTP/1.1 200 OK\r\nConnection: keep-alive\r\n\r\n${2:-"OK"}\r\n"
while { echo -en "$RESPONSE"; } | nc -l "${1:-8080}"; do
  echo "================================================"
done

#By Ruby WEBrick 起動
ruby -run -e httpd . -p 8000 &
ruby -run -e httpd -- --port 3000 .
curl -I localhost:8000/test.html

#By python
python -m http.server 8000




#timer display by mill sec
while true ; do printf "\r%.12s" `date +%T.%N`; sleep 0.01 ; done

#Brute force fot 4 digits
time seq -w 0 9999 | while read n ; do unzip -P $n -pq naisyo.zip && exit 0 ; done 2> /dev/null

#Generate Uniq ID 32charactor string  https://gist.github.com/earthgecko/3089509
CID=$(cat /dev/urandom | LC_CTYPE=c tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

#ランダムなデータを 20 バイト読み出し、16 進数で表示する
$ head -c 20 /dev/urandom | xxd -p
daa316709d39090488d71aeb37830e5c0bfe6d18

#base64 URL safe例:「+」と「/」をそれぞれ「-」と「_」に置き換える
$ head -c 20 /dev/urandom | base64 | sed ’s/=*$//’ | tr ’+/’ ’-_’ 2IxLgD-h1HTqWA16_6xGpyHPj3U

#Create Secure Password
ruby -r securerandom -e "puts SecureRandom.urlsafe_base64"

# ランダムな文字列生成(50文字)
python -c "import string, random; print(''.join(random.sample(string.ascii_letters+string.digits,50)))"
python -c "import string, random; print(''.join([random.choice(string.ascii_letters + string.digits) for i in range(50)]))"

openssl rand 20 -hex # 20バイトのランダムデータ(16進数) 76f1741c5fc7965aee35d8d4974bcc616d802482 # 40 文字
openssl rand 20 -base64 # 20 バイトのランダムデータ(Base64 方式) CbEoORMQNvdv0E+d0w7egwz+rak= # 27文字+1文字

### 暗号化(-e)
openssl enc -e -aes-256-cbc -salt -md sha256 \
< plain > plain.encrypted

### 環境変数にパスワードを設定(環境変数名は何でもよい)
export PASSWORD=‘openssl rand -base64 45‘
##または 暗号化や復号化のときは、sudoコマンドでパスワードファイルを読み込む
export PASSWORD=‘sudo cat $PASSWORD_FILE‘

### 暗号化時にパスワードが入った環境変数名を指定
openssl enc -e -aes-256-cbc -salt -md sha256 -pass env:PASSWORD

### 復号(-d)
openssl enc -d -aes-256-cbc -salt -md sha256 \
< plain.encrypted > decrypted.plain

#ファイル名一括置換
for F in ./bat/*bat.txt;do;mv $F ${F/bat.txt/sh};done

# 行と列を入替(縦横入替)
echo aa bb cc | tr ' ' '\n'
echo aa bb cc | python -c "import sys; print('\n'.join(' '.join(c) for c in zip(*(l.split() for l in sys.stdin.readlines() if l.strip()))))"
aa
bb
cc


#Useful shell 
#特定dir除外
find / -name '*asar*' -not -path "$HOME/*" 2> /dev/null
find . -type d -mindepth 1 -maxdepth 1 -exec du -hs {} \;
#or検索
find ./ -name '*.jpg' -or -name '*.jpeg' -or -name '*.png' | xargs open
#1h以内に更新したファイル
$ find / -mmin -60 2> /dev/null
#特定のファイルをバックアップdirに保存
find [target path(from)] -type f -name 'file名' | xargs -n 1 -I{} cp {} [To backup path]


#check listen port
lsof -nP -iTCP -sTCP:LISTEN

#pw generate
cat /dev/random | base64 | fold -w 10 | head -1


#証明書をPEMに openssl x509 -inform der -in cer.der -text
openssl x509 -inform der -in cer.der -text

#log
egrep '(GET|POST).*/follow.*HTTP' *.log --color -A10

#This command searches for log4shell exploitation attempts in uncompressed files in folder /var/log and all sub folders
sudo egrep -I -i -r '\$(\{|%7B)jndi:(ldap[s]?|rmi|dns|nis|iiop|corba|nds|http):/[^\n]+' /var/log

#This command searches for exploitation attempts in compressed files in folder /var/log and all sub folders
sudo find /var/log -name \*.gz -print0 | xargs -0 zgrep -E -i '\$(\{|%7B)jndi:(ldap[s]?|rmi|dns|nis|iiop|corba|nds|http):/[^\n]+'

# 監視
tail -f /var/logs/apache2/access.log | egrep --line-buffered -i -f ioc.txt |
tee -a interesting.txt

#ioc.txt
\.\./ 1
etc/passwd 2
etc/shadow
cmd\.exe 3
/bin/sh
/bin/bash


#重複削除
(^.*$)\n(^\1$)
vim で :sort u でも

#nkf encodeing
nkf --url-input -Ww
nkf -s --overwrite Untitled-4.htmlxx
nkf -g Untitled-4.html
nkf -w --overwrite Untitled-4.htmlxx
echo '%82%a0' | nkf --url-input -Sw | hexdump -C   #inputがsjis outがutf8



### ssh ###
ssh -p 9999 -i ~/.ssh/private.key name@172.23.xx.xx
ssh -A -t server.ad.local
scp -P 9999 ~/.ssh/p.key name@172.23.1.5:~/


# ssh接続時に直接コマンドを実行
ssh user@server '実行したいコマンド'
# ローカルのスクリプトをリモート先で実行
ssh user@172.16.0.1 'sh ' < /usr/myscript.sh
# リモート先のファイルにローカルファイルの内容を追記
ssh user@172.16.0.1 'cat >> /home/user/.ssh/known_hosts' < <(echo 'xxpubkey...xxx') 

# 踏み台サーバ経由でログイン
ssh user@172.16.2.1 -o 'ProxyCommand ssh internal@10.0.0.20 nc %h %p'
# 多段接続機能を使えば転送処理の為だけに踏み台サーバに入る必要はない。
scp -r -o "ProxyCommand ssh -i ~/.ssh/key {user}@{踏み台} -W %h:%p" testdir {user}@{target}:/tmp/.
もしくは
scp -r -o "ProxyCommand ssh -i ~/.ssh/key {user}@{踏み台} nc %h %p" testdir {user}@{target}:/tmp/.
# 上記２つの違いは、-Wオプションを使うか、nc (netcat)を使うかの違いである。 ncオプションの場合、踏み台サーバにもncが使えるようにしておく必要がある。
#  一方で-Wオプションの場合は、そこを意識しなくて良い。%h %pはそれぞれホスト、ポートを表している。

# scp
scp student@172.16.0.100:/etc/hosts .

#フィンガープリント確認
ssh-keygen -l -E md5 -f {pub.key}


#mount
mount -t smbfs //aduser@10.55.0.2/dir1 ~/test/


git credential-cache exit
#check sig?
jarsigner -verify -verbose -certs

#current user でsudoはできるけど、他の権限のないユーザのdirへアクセス権限がない場合にコピーしたい場合。
sudo -E git -C ../pentester/xxproject pull
sudo chown -R pentester:pentester ../pentester/xxproject


# IF文のような分岐処理をワンライナーで ->true
grep ssl oneLiner.sh > /dev/null && echo true || echo false



# パイプで渡したコマンドの終了ステータスを得る
cat oneLiner.sh|cat|cat|cat
echo ${PIPESTATUS[@]}
0 0 0
cat oneLiner.sh | cat|cat dcscs|cat
cat: dcscs: No such file or directory
bash-3.2$ echo ${PIPESTATUS[@]}
0 0 1 0

#sleep switch
while [ ! -e "./sleep.switch" ];do sleep 1;echo -n .;done &
sleepswitch() {
while [ -e ./sleepswitch.stop ]
do
 sleep 10
 echo -n .
done
}

#slack post
curl -sS -XPOST -d "token=${TOKEN}" -d "channel=#ch-name" -d "text=body部分:$text" -d "username=From shell" -d "icon_url=${ICON}" "${POST_API}" > /dev/null

#Apache HTTP Serverの2.2系を全部ソースインストールして、バージョンごとに別々のポートで起動。一行にできる。
for i in {0..34}; 
do wget http://archive.apache.org/dist/httpd/httpd-2.2.${i}.tar.gz;
 tar xf httpd-2.2.${i}.tar.gz; 
 pushd httpd-2.2.${i}; 
 ./configure --prefix=/opt/httpd/2.2.${i};
 make;
 make install;
 sed -i "s/Listen 80/Listen $((2000+${i}))/" /opt/httpd/2.2.${i}/conf/httpd.conf; 
 echo "TraceEnable Off" >> /opt/httpd/2.2.${i}/conf/httpd.conf; 
 /opt/httpd/2.2.${i}/bin/apachectl start; 
 popd; 
done



#### grep ####

# or検索
grep "keyword1\|keyword2" file.txt  # 拡張正規表現ではない？ egrep

#-e を使わないとファイル名と扱われてしまうので、注意が必要です。普段は省略していることが多いかも知れませんが、-eの後に記述されたものがパターンとして使用されます。
grep -e "GET .*\.js" -e "GET .*\.css" *.log 


# ●シェル芸人の心得  配列は使うな。数字や文字列を複数回比較する場合は AWKやgrepを使ったほうが良い場合がほとんど
# もちろん最低限のコマンドのオプションを覚えておくことは必要です。しかし、使うほうはあまりオプションに期待せず、 コマンドを組み合わせるスキルを身につけておいたほうが、CLIでできることが増えます。
# 「～する」ということ、つまり「目的：なぜコードを書くのか」という、コードを書く前の段階から意識してプログラムを考えたい。 目的から一直線に考えたならば、短いほうが良い。短いものは「それっぽいプログラム」よりもプログラムである。そう考えます。
# 制御構文と同じく、「なるべく変数を使わない」ことをお勧め。「データはなるべく標準入出力で扱うべき」というのがその理由です。 シェルの使い方が身につけば、自然にそうなることです。
# ただ、たった1つの数字でも変数ではなく躊躇なくファイルに保存したほうが良い場合もある場合もあります。 シェルスクリプトの場合、変数はおもにファイル名を動的に作るときに使います。
# シェルスクリプトで一時的なファイル（中間ファイル）を作るときの常套手段です。　
# bashでは配列が使えますが、使う必要がないどころか、配列の使い方を覚えるとかえって悪い癖がつくからです。
# 「変数をあまり使うな」と先述したことから帰結されるように、テストコマンドも多用してはいけません。 とくに数字や文字列を複数回比較する場合は AWKやgrepを使ったほうが良い場合がほとんどです。
# テストコマンドを積極的に使うケースとしては、シェルスクリプトで引数を受け取ったときに空文字かどうかを調べる場合があります。 また、ファイルやディレクトリの有無を調べるときにもテストコマンドは便利です。


######### sed ############
#テキスト処理ツール。言語ですのでさまざまな使い方ができますが、たいていは文字列の置換に使われます。
# 置換する時に重宝。AWKのsubなどとの使い分けですが、AWKの場合は狙った列の文字列だけを置換できるので、その必要がある場合はAWKを使います。
# ●sedの動き
   
  # 1. fileから1行読み込んでパターンスペースに格納
  # 2. addressにマッチ？  →commandを実行
  # 3. パターンスペースを表示
      

#先頭文字を大文字に foo->Foo
eval `echo foo | sed 's/\(.\)\(.*\)/\/bin\/echo -n \1 | tr "[a-z]" "[A-Z]";echo \2/g'`
  # 結局このコマンドを実行している。　/bin/echo -n f | tr "[a-z]" "[A-Z]";echo oo
echo `echo foo | sed 's/\(.\)\(.*\)/\/bin\/echo -n \1 | tr "[a-z]" "[A-Z]";echo \2/g'`

# 空白行削除
sed '/^$/d' a.txt

#  -e     続けて編集コマンドを記述  (e xpression の略）
#  -i    上書きでテキストを修正   i.bak で拡張子を付ければ新たに作ってくれる
#  -f    ファイル名を指定  （  sed -f [スクリプト] file.txt）  スクリプト→/lh/LH 等書かれたファイル
#  $ sed [オプション] [編集コマンド] [ファイル名]
#  $ sed -e [編集コマンド1] -e [編集コマンド2] ... [ファイル名]     編集コマンドが一つの場合省略可
 

# 置換系

# s コマンド   "文字列"の置換   substitution
#  「///」   スラッシュでなくてもよい 「.」とか 「;」等 -> (正規表現使いたい場合や、「/」自体を対象にしたい時とか)

# ━文字を一括置換 -iで上書き
#  $ sed -e "s/\(charset=\)EUC-JP/\1UTF-8/i" -i *.html
       
# フラグとは  ※フラグは複数組み合わせ可
#   フラグ「g」      … global  全ての文字列を対象。1行で何度も置換しろ 
#   フラグ「(数値)」 … n番目を対象。 
#   フラグ「i」      … 大文字小文字を区別しない
  
#   sed -e 's/●/■/'    1行の中で最初の文字列だけ置換  1行で一回 
#   sed -e 's/●/■/2'   2番目にマッチする文字列を置換      
#   sed -e 's/●/■/g'    全ての文字列を置換 
#   sed -e 's/●/■/ig'   大文字小文字を区別しないで文字列を置換 
#  「●」…検索文字列(正規表現)  「■」…置換文字列    正規表現の時は「''」でくくる


  # マッチした文字列の再利用（キャプチャ） ->先頭のecho以降をキャプチャ
  sed 's/^echo \(.*\)/xx\1xx/g' t.sh
  # 指定ディレクトリのファイルを再帰的に置換
  sed 's/"\([^"]*\)"/"After"/g' < $(find ./ -iname '*.sh' -type f) | grep After
  find ./ -iname *.sh -type f | xargs sed 's/"\([^"]*\)"/"After"/g'
  #特定の行(4,8行目)にある特定の文字列を置換
  sed '4,8s/Line/gyou/g' file
  #特定の文字列を含む行にある特定の文字列を置換(多分正規表現いける)
  sed '検索文字列s/春/秋/g' file
  sed '/echo/d' t.sh  #特定の文字列を含む行のみ削除する
  # ””で囲まれた値を抽出 (一箇所のみ)
  sed 's/^.*"\(.*\)".*$/\1/' t.sh
  # ””で囲まれた値を置換
  sed 's/"\([^"]*\)"/"After"/g' t.sh
  #3番目にマッチする文字列を置換（行毎に。その行で３番目）
  sed 's/春/秋/3' file

#挿入、上書き系
  # 指定した行に任意の行を挿入する。後ろはの場合4a insertlineで
  gsed '4i insertline' t.sh
  gsed -e '1,3a ======' csv.csv #1-3行目までに挿入
  gsed '1,3d' t.sh  #1-3を削除
  #特定の文字列を含む行のみ挿入する
  gsed '/echo/i ingectline' t.sh  
  #指定行の内容を上書き
  gsed '3c inject to 3' t.sh
  # 特定キーワードを持つ行の内容を上書き
  gsed '/echo/c ReWrite!' t.sh


# 複数条件 -e
gsed -e '3c inject to 3' -e '4i insertline' t.sh


# 小文字大文字変換
gsed 's|\(.*\)|\U\1|' <(echo ABCabc)
gsed 's|\(.*\)|\L\1|' <(echo ABCabc)



######## awk #############
# AWKは、二次元のテーブルデータに最適化された言語（行に各レコードがあって、レコードは何かを区切り文字にしていくつかのフィールドで構成されるデータ）
# awkでは入力レコードの区切りを変更し、行以外の入力単位で処理させることもできる。
# 古くからのスクリプト言語。（1977年生まれ。読み方は「オーク」
# 毎行処理(Transducer)! , 行指向プログラミング, C言語like
# AWKは、二次元のテーブルデータに最適化された言語です。 └（行に各レコードがあって、レコードは何かを区切り文字にしていくつかのフィールドで構成されるデータ）
# 「プログラミングから実行、テストまでが俊敏に実施できる軽量性」、「システムの深淵まできめ細やかに操作できる」
# ストリームに対する処理に特化した構造
# └→ 入力列があることを前提としてその入力パターンに対応した、アクションを実施する
# ログファイルからごにょごにょ
# テキストを1行読み込んで、読み込んだ行を空白区切りのデータと解釈して、何らかの処理を行う。 以上の動作を、行末まで繰り返す。
# awk(1)の実体は、GNU Awkというもの。  ややこしいことにAWKという言語を解釈して実行するプログラムには亜種がたくさんあって、どれも少しずつ挙動が変わります。
# こんなイメージ sudo find /etc | head -n 5 | xargs file | awk '{print NR " --"$2,$1}'
  #  1 --directory /etc:
  #  2 --directory /etc/grub.d:
  #  3 --POSIX /etc/grub.d/20_linux_xen:
  #  4 --POSIX /etc/grub.d/40_custom:
  #  5 --POSIX /etc/grub.d/30_os-prober:




#  gawk '$1~/正規表現/{print "インド発見！"}' f.txt
#        ~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~~~   その行の１カラム目が正規表現に一致する場合、actionを行う。 
#        [Patarn]    [Action]


# $1,$2,... :分割されたフィールドはその順番にこの特殊変数に格納される
# $0        :レコード全体（全てのフィールド？） {print;} ->printに変数を与えないと、行全体を出力するという同じ意味になります。

#     $0には行全体が入っています。さらに、次のようにある列の値をいじっても、$0に反映されます。
#     vagrant@ubuntu-14:~$ echo {a..h} | awk '{$3="hoge"; print $0}'
#     a b hoge d e f g h


# NF       : 今読み込んでいるフィールドの数。各行の列数 number of fields
# NR       : 何番目のレコードか。読み込んだレコード数が格納される。複数ファイルを読み込んだ場合はそれらの合計が格納される。ordinal number of the current record
# FNR      : 現在のファイルのレコード番号が格納される。
# FILENAME : 現在の入力ファイル名が格納
# FS       : 入力フィールドの区切り文字を定義しておく変数。 正規表現も可能。 BEGINの箇所で定義が普通？
# RS       : 入力レコードの区切り文字を定義する変数。  定義しない場合、復帰改行が規定値

# OFS      : 出力フィールドの区切り文字を定義しておく変数。 定義しない場合スペースが規定値
# ORS      : 出力レコードの区切り文字を定義しておく変数。 定義しない場合復帰改行が規定値
# OFMT     : 出力書式を定義する変数「%.6g」が規定値（数値のprint文において）

# ARGC     : 引数の数 (コマンドラインの)
# ARGV     : 引数の配列(コマンドラインの) ...

# 特定のN行を表示  (NRは「各行番号」？)
cat README.txt | awk 'NR==15'
#特定の列のみ出力
awk '{print $2,$4}' data01.dat

#デリミタを指定し、規則性のある任意の要素を取得
cat file
    ringo [100] 200ko [20]
    mikan 200 30ko[][50]
    tea 100
    gratan cheese po[t]ato tomato[100]
cat file | awk -F '[][]' '{print$4}'
20
50

100
#特定のフィールドの値に応じて出力 ↓の例は 数値、文字列、正規表現
awk -F '[][]' '$4 >= 100 && $2=="t" || $4 ~/1[0-9]+/' file
     gratan cheese po[t]ato tomato[100]



# 空行を削除 (NFは「各行の列数」) sed '/^$/d'
cat README.txt | awk 'NF'

#文字数カウント(wc -c と同じだが結果違うので注意)
awk '{n+=length($0)} END{print n}'
#単語数カウント(wc -w)
awk '{n+=NF} END{print n}'
#行数カウント(wc -l)
awk 'END{print NR}'

# 行末の空白やタブを削除
awk '{ sub(/[ \t]+$/, "") }1'

# Windowsの改行コードに変換する ->To Unix改行コード sub(/\r$/,"")
awk 'sub(/$/,"\r")'

#stdoutにそのまま出力 cat - 
awk '1'
#grepと同じ
awk '/line/' #grep -v  awk '! /line/'
# コメント削除
awk '! /^#/'
#複数行またがりコメント削除  /* この中（複数行） */
awk '/\/\*/, /\*\//{next}{print}'

# 指定行間の行を表示
awk 'NR==2,NR==4'
# 偶数行を表示
awk 'NR%2==0'  #奇数は awk 'NR%2'

# 特定の列（feild)数を持つ行のみ出力
cat file
  ringo 100 200ko
  mikan 200 30ko
  tea 100
  gratan cheese potato tomato
cat file | awk 'NF>=2 && NF<=3'
  ringo 100 200ko
  mikan 200 30ko
  tea 100

#mailxでメールを送る。localhost
から送れるみたい




#ps とかのProcess確認
ps fu -A | grep 'jibun no uid etc' --color
