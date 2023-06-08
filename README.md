- [Might be helpful](#might-be-helpful)
- [複雑なワンライナーを説明してくれる](#複雑なワンライナーを説明してくれる)
- [Setup use own commands in your environment](#setup-use-own-commands-in-your-environment)
- [More learning](#more-learning)
- [set -euやっとくと良い](#set--euやっとくと良い)
  - [set -u](#set--u)
    - [変数のデフォルト値の扱い](#変数のデフォルト値の扱い)
  - [set -e](#set--e)
  - [set -v](#set--v)
  - [set -x  実行コマンドを表示](#set--x--実行コマンドを表示)
  - [文法チェック](#文法チェック)
- [-vと-xの違い](#-vと-xの違い)
  - [「-v」は読み込んだスクリプト行をそのまま表示します。](#-vは読み込んだスクリプト行をそのまま表示します)
  - [「-x」は実行するコマンドを表示します。](#-xは実行するコマンドを表示します)
- [\&\& や || は、テスト用コマンド「\[ \]」と組み合わせてよく使われます](#-や--はテスト用コマンド-と組み合わせてよく使われます)
- [\[\[\]\]の方が高機能でバグを作りにくいので\[\[使うべし](#の方が高機能でバグを作りにくいので使うべし)
- [if文チートシート](#if文チートシート)
- [シェルスクリプトの冒頭に以下を追記しておくと、実行場所を気にしなくてよいスクリプトになる。](#シェルスクリプトの冒頭に以下を追記しておくと実行場所を気にしなくてよいスクリプトになる)
  - [dirname コマンドや basename コマンドと似たようなことができます。しかし、以下のような違いがあるため、dirname コマンドや basename コマンドの代わりとして変数展開を安易に使うのはやめましょう。](#dirname-コマンドや-basename-コマンドと似たようなことができますしかし以下のような違いがあるためdirname-コマンドや-basename-コマンドの代わりとして変数展開を安易に使うのはやめましょう)
  - [bash置換の書式について](#bash置換の書式について)
- [グルーピング、サブシェルを使って1つにまとめる](#グルーピングサブシェルを使って1つにまとめる)
  - [2つのコマンドをバックグラウンドで実行したい、かつ順番に実行する](#2つのコマンドをバックグラウンドで実行したいかつ順番に実行する)
  - [またグルーピングを使うと、複数のコマンドの出力があたかも 1 つのコマンドによる出力か のように扱えます。たとえば次の例では、3 つの echo コマンドの出力を 1 つのパイプで受け 取っています。](#またグルーピングを使うと複数のコマンドの出力があたかも-1-つのコマンドによる出力か-のように扱えますたとえば次の例では3-つの-echo-コマンドの出力を-1-つのパイプで受け-取っています)
- [echoの出力先を標準エラーにする](#echoの出力先を標準エラーにする)
- [trap:シグナルをキャッチし割り込みの制御](#trapシグナルをキャッチし割り込みの制御)
  - [疑似シグナル](#疑似シグナル)
  - [スクリプト終了時の処理を登録](#スクリプト終了時の処理を登録)
- [外部スクリプトのエラーをハンドリング](#外部スクリプトのエラーをハンドリング)
    - [caller\_handller.sh](#caller_handllersh)
    - [std\_out\_or\_error.py](#std_out_or_errorpy)
    - [Run](#run)
- [ログの出し方](#ログの出し方)
- [localやreadonlyを付けて変数を定義する](#localやreadonlyを付けて変数を定義する)
  - [cron](#cron)
- [並列で実行させる](#並列で実行させる)
- [正規表現の先読み、後読みとか (?\<=hoge)foo(?!bar) みたいなの](#正規表現の先読み後読みとか-hogefoobar-みたいなの)
- [環境変数による切替で色んなパラメタで試せる(envdir)](#環境変数による切替で色んなパラメタで試せるenvdir)
- [crypton で暗号処理](#crypton-で暗号処理)
- [ディレクトリ移動](#ディレクトリ移動)


50行を超える場合や複雑な事をやる場合、bashにこだわる必要は無い。  

### Might be helpful
https://qiita.com/xtetsuji/items/381dc17241bda548045d  
https://qiita.com/rsooo/items/ef1d036bcc7282a66d7d
### 複雑なワンライナーを説明してくれる
https://explainshell.com


### Setup use own commands in your environment
```sh
mkdir $HOME/bin
PATH=$PATH/$HOME/bin
```
or
```sh
ln -s {xx.sh} /bin/xxx
#とかでリンクさせてやるやりかたでもよい。名前衝突にきをつける
```
### More learning
- スクリプトの定型テンプレート等のtips
https://www.m3tech.blog/entry/2018/08/21/bash-scripting


### set -euやっとくと良い
https://qiita.com/youcune/items/fcfb4ad3d7c1edf9dc96

#### set -u  
未定義の変数を参照するとエラーとして扱う。

`./t.sh: line 5: VAR: unbound variable`この時点で停止するぽい

結果として変数名が間違ってい るとエラーになってくれます。
これにより、変数名のタイプミスや初期化わすれでの変数の利用などを防ぐことができます。
これはデフォルト値指定をすれば回避可能

##### 変数のデフォルト値の扱い
https://qiita.com/minanon/items/d3c7dd0a74ea4f455551

```sh
#こんな感じにしとくと、未定義でもデフォルト値 ./ を設定してくれる
${store_dir-./}

# 必須パラメタ確認。パラメータ展開を利用の未定義確認
if [ -z "${ip+UNDEF}" ] || [ -z "${exec_nmap+UNDEF}" ];then
    _disp_help; exit 0
fi
```

#### set -e 
終了ステータスが０以外なら終了。つまりコマンドの実行がエラーになったらスクリプトも終了する  
注意点として、grepやlsなどのコマンドは結果が0件になるような場合に終了コードが0以外になるので、 そういう場合は一時的に-eオプションを解除するようにする必要があります。

```sh
set -e
echo "エラー終了する範囲"

set +e # 一時的にエラーで停止しないようにする
res=$(grep "hoge" myfile.txt)
RET=$?  # コマンドの終了値を取得するときはsetの前に保存しないと、$?がsetコマンドの結果で上書きされる
set -e # 再度、有功化

# 以下のように最後に必ず正常終了するコマンドをつなげることでも回避できます
grep "hoge" mfile.txt || true

#こんな感じで制御文入れると、エラーでも止まらない時があるので注意。二行でかくと期待した動きになる
mv data dest/data && echo "[+] Copy to $STOREDIR/$YYYYMMDD/$RESULT_FILE"
```

#### set -v  
  をつけると、読み込んだシェルスクリプト の行を表示してから実行します。これによって、スクリプトのどの行がどんな出力を行ってい るか、簡単に分かります。  
  シェルスクリプトの「set -e」だけでは不十分です。Bashが使えるならな るべくBashを使い、「set -o pipefail」も指定しましょう。
パイプでのコマンドがエラーになるとスクリプトも終了してくれるようになります。

 - -v オプションは、デバッグにおいて「出力結果のここがおかしいのだけど、これはスクリプトのどこで出力されているのだろうか?」を調べるときに重宝します。
なお「-v」オプションをつけるかわりに、スクリプト中で「set -v」と書いてもいいです。 「set -v」でオン、「set +v」でオフにできます。これを使うと、スクリプトの一部だけ表
示する(または一部だけ表示しない)ことができます。

#### set -x  実行コマンドを表示  
行頭に「+ 」がついてコマンドが表示されます。
□実行例:コマンドの頭に「+ 」がついて表示されている

```sh
date
message="Hello World"
echo $message # 変数を使っていることに注意
```
```sh
$ bash -x ex-debug4.bash
+ date
Sun Jul 08 23:31:05 JST 2018 + message=’Hello World’
+ echo ’Hello World’
Hello World
```
#### 文法チェック
```sh
bash -n test.sh
```

### -vと-xの違い

#### 「-v」は読み込んだスクリプト行をそのまま表示します。
+ コメントや空行も表示されます。
+ 「ls *.png」は「ls *.png」のまま表示されます。
+ if文は、if 文のまま表示されます。
+ for 文が 3 回ループする場合でも、for 文自体は 1回しか表示されません。

#### 「-x」は実行するコマンドを表示します。
* コメントや空行はコマンドでないため、表示されません。
* 「ls *.png」は「ls A.png B.png C.png」のように表示されます。 
* if 文は、条件式のコマンドが表示され、そのあと if 文自体も表示されます。
* for 文が 3 回ループする場合は、for 文も 3 回表示されます。

ここが綺麗にまとまってて見やすい
https://shellscript.sunone.me/


### && や || は、テスト用コマンド「[ ]」と組み合わせてよく使われます

```sh
[ -z "$name" ] && name="World" # 値が空ならデフォルト値を設定 
[ -d foo.d ] || mkdir -d foo.d # ディレクトリがなければ作成
[[ -d /tmp/dir1 ]] || mkdir /tmp/dir1  #同じくなければ作成
# 同じくディレクトリがないときだけ作成!!
mkdir -p /tmp/build
## 便利！！ディレクトリ階層を作成(すでに存在していてもエラーにならない) 
mkdir -p /tmp/aa/bb/cc

[ "$x" -lt 0 ] && exit 1 # $x < 0 ならエラー終了

前のコマンドが失敗したときだけ次のコマンドを実行
grep -q ˆubuntu: /etc/passwd || sudo adduser ubuntu

# IF文のような分岐処理をワンライナーで ->true
grep ssl oneLiner.sh > /dev/null && echo true || echo false

# 複数の処理をさせたい時はグルーピングも併用すると良い。
GREP="grep"
if [[ "$(uname -s)" = 'Darwin' ]];then
    type "ggrep" > /dev/null 2>&1 && { GREP="ggrep"; echo some command; } || { echo 'GNU grep(ggrep) is required, please install it)'; exit; }
fi
```


### [[]]の方が高機能でバグを作りにくいので[[使うべし
https://takuya-1st.hatenablog.jp/entry/2017/01/02/163036

[], [[]]どちらも同じように使えますが、複数の条件を AND や OR で繋げる場合は違いがあるので 注意してください。
```sh
v1= v2=
## 「[ ]」のときは「-a」が AND、「-」が OR を表す 
if [ -z "$v1" -a -z "$v2" ]; then
 echo ’Neither $v1 nor $v2 specified.’ 
elif [ -n "$v1" -o -n "$v2" ]; then
 echo ’$v1 or $v2 specified.’ 
fi

## 「[[ ]]」のときは「&&」が AND、「||」が OR を表す 
if [[ -z "$v1" && -z "$v2" ]]; then
 echo ’Neither $v1 nor $v2 specified.’ 
elif [[ -n "$v1" || -n "$v2" ]]; then
 echo ’$v1 or $v2 specified.’ 
fi

```
### if文チートシート
if 文は終了ステータスを判定するのみなので、ls 等の一般的なコマンドを指定しても問題はない。

- 数値は `-eq`,`-ne`,`-gt(>)`, `-le(<=)`とか。
- 文字は `=`, `!=`, `-z`(長さが0), `-n`(長さが1以上)
- ファイル比較は `-e, -d, -s, -x, -ot, -nt`とか？

<details>
  <summary>Option list</summary>
  
```sh
str1 = str2		# 文字列 str1 と str2 が等しければ
str1 != str2		# 文字列 str1 と str2 が等しくなければ>
-z str			# 文字列 str が0文字であれば(zero)
-n str			# 文字列 str が0文字で以上であれば(not zero)
str			# 文字列 str が0文字で以上であれば(-n str と同じ)
num1 -eq num2		# 数値 num1 が num2 と等しければ(equal)
num1 -ne num2		# 数値 num1 が num2 異なっていれば(not equal)
num1 -ge num2		# 数値 num1 が num2 以上であれば(grater than or equal)
num1 -gt num2		# 数値 num1 が num2 より大きければ(grater than)
num1 -le num2		# 数値 num1 が num2 以下であれば(less than or equal)
num1 -lt num2		# 数値 num1 が num2 より小さければ(less than)
file1 -ef file2	# ファイル file1 が file2 と同一実体であれば(equal file)
file1 -nt file2	# ファイル file1 が file2 より新しければ(newer than)
file1 -ot file2	# ファイル file1 が file2 より古ければ(older than)
-e file			# ファイル file が存在していれば
-s file			# ファイル file が0バイト以上であれば
-f file			# ファイル file がレギュラーファイルであれば
-r file			# ファイル file が読み込み可能であれば
-w file			# ファイル file が書き込み可能であれば
-x file			# ファイル file が実行可能(ディレクトリの場合は移動可能)であれば
-d file			# ファイル file がディレクトリであれば
-h file			# ファイル file がシンボリックリンクファイルであれば(-Lと同義)
-L file			# ファイル file がシンボリックリンクファイルであれば(-hと同義)
-b file			# ファイル file がブロックデバイスファイルであれば
-c file			# ファイル file がキャラクタデバイスファイルであれば
-p file			# ファイル file が名前付きパイプであれば
-S file			# ファイル file がソケットファイルであれば
-k file			# ファイル file にスティッキービットが設定されていれば(chown o+t)
-u file			# ファイル file にセットユーザIDビットが設定されていれば(chown u+s)
-g file			# ファイル file にセットグループIDビットが設定されていれば(chown g+s)
-O file			# ファイル file が実効ユーザIDに所有されていれば
-G file			# ファイル file が実効グループIDに所有されていれば
-t fd			# ファイルディスクリプタ fd がターミナルとして開かれていれば
```

</details>


```sh

if 条件式1 ; then
  処理1
elif 条件式2 ; then
  処理2
else
  処理3
fi

ーーーーーーーーーーーーーー
if ls file1 file2 >/dev/null 2>&1; then
  # 古いほうを削除する
  if [ file1 -ot file2 ]; then
    echo "remove file1."
    rm -f file1
  else
    echo "remove file2."
    rm -f file2
  fi
else
  echo "file not found..."
  exit 1
fi

ーーーーーーーーーーーーーー
if echo "$var" | grep "hoge" >/dev/null 2>&1; then
  echo "hoge が見つかりました。"
fi

if grep BUNDLE_VERSION /usr/local/bin/meteor >/dev/null 2>&1 ; then
fi

if dpkg -s meteor >/dev/null 2>&1 ; then
fi

ーーーーーーーーーーーーーー
PIP_OUTPUT=$(pip3 install -r requirements.txt)
PIP_ERROR_CODE=$?

    echo "$PIP_OUTPUT"
    if [ $PIP_ERROR_CODE = '0' ]; then
        echo "[ + ] Pip install finished. (exit $PIP_ERROR_CODE)"
    else
        echo "\\033[38;5;202m[ - ] Pi..."
        exit 1
    fi
ーーーーーーーーーーーーーー

UNAME=$(uname)
# Check to see if it starts with MINGW.
if [ "$UNAME" ">" "MINGW" -a "$UNAME" "<" "MINGX" ] ; then
fi

ーーーーーーーーーーーーーー
# 標準出力があるか？
if [[ -p /dev/stdin ]]; then
else
fi
```


### シェルスクリプトの冒頭に以下を追記しておくと、実行場所を気にしなくてよいスクリプトになる。
```sh
cd `dirname $0` || exit 1
```
#### dirname コマンドや basename コマンドと似たようなことができます。しかし、以下のような違いがあるため、dirname コマンドや basename コマンドの代わりとして変数展開を安易に使うのはやめましょう。

```sh
#実行先ディレクトリに移動。変数内の文字列を後方一致除去(最短一致)
cd ${0%/*}  
# スクリプトが配置されているdirをカレントdirとして想定したシェルスクリプトを作成できることを意味する。 https://www.qoosky.io/techs/927115250f
# echo ${0##*/} #ファイル名だけ取得  (先頭から最長一致で取り除く.先頭から最後のスラッシュまでを取り除く。)


var1="/api/v1.0/index.html" 
var2="/api/v1.0/" 
var3="index.html"

## dirnameと違い、変数展開ではパス名がとれないことがある
echo ${var1%/*}
echo ${var2%/*}
echo ${var3%/*}
dirname $var1
dirname $var2
dirname $var3
#=> /api/v1.0 #=> /api/v1.0 #=> index.html #=> /api/v1.0 #=> /api
#=> .

## basenameと違い、変数展開ではファイル名がとれないことがある
echo ${var1##*/}
echo ${var2##*/}
echo ${var3##*/}
basename $var1
basename $var2
basename $var3
#=> index.html #=> (空文字列) #=> index.html #=> index.html #=> v1.0
#=> index.html
```
#### bash置換の書式について
    ${変数%マッチパターン} 後方からの検索の一致で一番初めにマッチした部分を削除
    ${変数%%マッチパターン} 後方からの検索の一致で一番後ろまでマッチした部分までを削除
    ${変数#マッチパターン} 前方からの検索の一致で一番初めにマッチした部分を削除
    ${変数##マッチパターン} 前方からの検索の一致で一番後ろまでマッチした部分までを削除
    ${変数/文字列/処理後文字列} 最初にマッチしたもののみ文字列を置換
    ${変数//文字列/処理後文字列} 全ての文字列を置換   

    文字列置換(1回だけ) echo ${var/i/I}
    文字列置換(全部) echo ${var//i/I}
    部分文字列(長さ指定あり) echo ${var:1:3}, echo ${var:10:5}
    部分文字列(長さ指定なし) echo ${var:1}, echo ${var:10}
    文字列の長さ echo ${#var}
```sh
### 拡張子を取り出す(最長前方一致による削除)
echo ${var##*.} #=> html
### 拡張子を取り除く(最短後方一致による削除)
echo ${var%.*} #=> /api/v1.0/
### 拡張子を変更する(文字列置換)
echo ${var/.html/.json} #=> /api/v1.0/index.json
```

### グルーピング、サブシェルを使って1つにまとめる

グルーピングを使って 2 つのコマンドをあたかも 1 つのコマンドのよう にすれば、2 つのコマンドを順番に実行しつつ、かつ全体をバックグラウンドで実行できます
が、、
グルーピング「{ ... }」はなるべく使わず、問題の少ないサブシェル「( ... )」を使うようにしましょう

#### 2つのコマンドをバックグラウンドで実行したい、かつ順番に実行する 
```sh
(# サブシェル
  sudo apt-get update
  sudo apt-get install nginx
) &

# (「{」と「}」がそれぞれグルーピングの開始と終了を表す)
[ -f "file.txt" ] || { echo "file not exist." >&2; exit 1; }
#グルーピングを使って 1 行で書くときは、「{」の直後と「}」 の直前に空白を入れてください。さもないとシンタックスエラーになります。
```
#### またグルーピングを使うと、複数のコマンドの出力があたかも 1 つのコマンドによる出力か のように扱えます。たとえば次の例では、3 つの echo コマンドの出力を 1 つのパイプで受け 取っています。
```sh
# echo コマンドが 3 つあるのに、その出力があたかも1つのコマンドによる出力かのように扱える
{
  echo "aa"
  echo "bb"
  echo "cc"
} | cat -n

#そのおかげで、たとえばechoコマンドを何度も実行する場合、そのたびに「>> file」を 繰り返すことなく、1 回だけで済ませられます。
# 通常なら echo コマンドごとに行っているリダイレクトが、
echo "aa" > output1.log
echo "bb" >> output1.log
echo "cc" >> output1.log

### グルーピングを使うと1回だけで済む 
(
  echo "aa"
  echo "bb"
  echo "cc"
) > output2.log

```
### echoの出力先を標準エラーにする
```sh
#a.sh
if [[ {hoge} ]];then
 echo "json data is wrong..." 1>&2; exit 1
fi

./a.sh 2> out
#outに書き込まれる

#stderrを全部表示させたい場合は逆で
echo Display all message! 2>&1
```

### trap:シグナルをキャッチし割り込みの制御
trap はシグナルを補足(trap) するためのシグナルハンドラを設定するためのビルトイン。 シェルスクリプトを長時間動かすユースケースに、別言語で実装されたバッチプログラムの起動だったり、ファイルツリーを探索して何か集計したりするとか、他システムとファイルを送受信など。 こういう長時間動かすケースでは、「意図せずシグナルを送られちゃったりした時のことを考えなければならないケースがあります。

- この処理をしてるときにシグナルを受け取ってしまったら、変な一時ファイルが置かれたままになっちゃう
- シグナルが発生したときは、ログだけは出して終了しなきゃ  

例えば長い処理とかでそのプロセスの状況を知りたい時とか、特定のシグナルに何か処理をさせることもできる
- 例えば `SIGINT`シグナル※を受信するとデフォルトではスクリプトが終了しますが、 こんな風にtrap で捕まえてやると終了せずに継続することも可能。 
  -  `trap 'echo 何もしない' INT`  
     -  (`kill -15 {pid}`、 `ctr+z`してkillするとかで止められる) .   
  - ※割り込み (INTerrupt)。端末から実行したシェルスクリプトなら Ctrl+c で送信可
- `trap 'echo "Try count $count.." USR1` で `kill -s USR1 {pid}` をすると状況を確認できる. 
- 自動化させたい時、pidは該当処理を外部呼び出しスクリプトにして`$$`とかで取得できる

####  疑似シグナル
trap ではシグナルハンドラを指定できるわけですが、ここで指定できるシグナルというのは SIG から始まる実シグナルだけではありません。 疑似シグナルという、シグナルのようであってシグナルではないものを指定することができ、これによって便利な使い方ができるようになります。

疑似シグナルとしては、以下のようなものがあります。
- ERR
  - コマンドの実行結果が0以外(Not Zero)のステータスであった場合に送出される疑似シグナル
```bash
#エラーが発生したときに「どのファイルの」「どの行で」「どのコマンドが」エラーとなったのかを標準出力に出力する
trap 'echo "[$BASH_SOURCE:$LINENO] - "$BASH_COMMAND" returns not zero status"' ERR

echo "hello world"
ls /not-exist-file

#実行結果
hello world
#ls: cannot access '/not-exist-file': No such file or directory
[./trap-err.sh:5] - ls /not-exist-file returns not zero status
```
- EXIT (0)
  - スクリプトが終了した時点で送出される(と考える)疑似シグナルです。 一時ファイルを片付けるときなどに使ったり
```sh
sh -c 'trap "echo Bye!" EXIT; echo "Hello!"; echo MUMUmm && echo teest'
Hello!
MUMUmm
teest
Bye!
```
- DEBUG
  - コマンド毎に送出される(と考える)疑似シグナル。シェルが何を実行しようとしているのかを確認しながら実行を進めることができる
- RETURN (bash のみ)
  - 関数や .、source で実行したスクリプトから戻った時 


See more..   
https://fumiyas.github.io/2013/12/05/trap-exit.sh-advent-calendar.html

#### スクリプト終了時の処理を登録
trap の使い方でいちばんよくあるのは、スクリプトが終了したときの後始末を登録すること。そのためには、シグナル番号として「0」を指定します。こうすると、スクリプト がエラーで途中終了しても、後始末が必ず実行されます。スクリプトの最初の方で定義するのがお決まりぽい？

```sh
tmpdir=/tmp/build
trap "rm -rf $tmpdir" 0  # ディレクトリを削除する処理を登録
mkdir -p $tmpdir
echo Hello > $tmpdir/data 
cat $tmpdir/data
exit 1   # ディレクトリを削除せずにエラー終了

#シェルスクリプト中で使う場合は、作成した一時ファイルを確実に消しましょう。そのためにtrap コマンドを使います。

tmpfile=`mktemp` # 一時ファイルを作成
trap "rm -f $tmpfile" 0 # スクリプト終了時に確実に削除

#一時ファイルの作成場所は、「-p」オプションで変更できます。Linux のデフォルトでは 「/tmp」の下に作成されるため、他のユーザが一時ファイルにアクセスできる可能性がありま す*22。そのため、自分しかアクセスできないディレクトリを作り、そこを指定するのがいい
でしょう。

$ mkdir -m 700  ̃/tmp # 自分しかアクセスできないディレクトリを作成 
$ mktemp -p /tmp buffer-XXXXXXXXXX.tmp
#/home/ubuntu/tmp/buffer-gyJGMmsyrX.tmp

###### tempfileで作成し、完了したら適切な場所へ移動する ######
COMMAND=$1
LIST=$2
FILE=`date "+%Y%m%d_%H%M%S"`_${COMMAND}_target.list
YYYYMMDD=`date "+%Y%m%d"`
STOREDIR="data"
tempfile=`mktemp`
trap "echo 'Something error..'; rm -f $tempfile" ERR

echo "[+] Getting data $YYYYMMDD "
time pipenv run ./main.py $COMMAND --file ./$LIST | tee $tempfile

mkdir -p $STOREDIR/$YYYYMMDD && mv $tempfile $STOREDIR/$YYYYMMDD/$FILE && \
cp $LIST $STOREDIR/$YYYYMMDD && echo "[+] Copy to $STOREDIR/$YYYYMMDD"

echo "[+] Output to $STOREDIR/$YYYYMMDD/$FILE"

```
Useful link.
- https://kiririmode.hatenablog.jp/entry/20160730/1469867810
- install_meteor.sh


### 外部スクリプトのエラーをハンドリング
##### caller_handller.sh
```bash
#!/bin/bash
#set -e
# ↑これを有効にするとreturn codeでハンドリングするまでも無く、errorが発生したところで中断する

./std_out_or_error.py
return_code=$?

if [[ "$return_code" != '0' ]];then
 echo "./std_out_or_error.py is return Not 0(std error)"; exit 1;
fi

echo 'Finished ./std_out_or_error.py and this script!'
```
##### std_out_or_error.py 
```bash
#!/usr/bin/env python
import sys

# For stdout
print('exit to stdout!!')
sys.exit()

# For stderr
#print('stderr: print() exit!!', file=sys.stderr)
#sys.exit('stderr: exit--!')
```
##### Run 
```sh
./caller_handller.sh
exit to stdout!!
Finished ./std_out_or_error.py and this script!
```

### ログの出し方
ログを出力するときに、処理中のファイルや関数、実行行数などを出力することができます。

```sh
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo -e "$(date '+%Y-%m-%dT%H:%M:%S') ${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]} $@"
}

log "message"
#=> 2017-01-20T10:53:03 myscript.sh:10:main message
```
https://qiita.com/Ets/items/cd3baa5cecbf553f822d

### localやreadonlyを付けて変数を定義する

bashではfunction内で定義した変数もグローバル変数になります。 それを避けるためにfunction内で変数を定義するときはlocalを付けてください。 もし、それを付けずに意図的にグローバル変数を定義しようとしてるときは、何か無茶をしようとしていると思って再考してください。

ただし、localの変数のスコープは普通のプログラミング言語とは異なるので過信しすぎないように注意してください。
localはそれが宣言されたブロック内の呼び出し全てに影響します。

```sh
function hoge() {
  local val1=100 # これはfunction内部から呼び出されたコマンドの先まで影響する

  fuga # この関数内でも参照できる
}

#基本的にグローバル変数の使用は推奨しない
readonly WORKDIR=/tmp/workspace
readonly LOGFILE=$WORKDIR/app.log
INPUT_MESSAGE=$1
```


#### cron
基本環境変数が反映されないので、確認してみると良い
```sh
#動作確認用 1分おき
* * * * * env > ~/cron_env
```
解決方法として以下
- cron実行時にPATHを任意のPATHで上書きする
- source ~/.bash_profile を書いてから目的のコマンドを記載する。
- bash -l -c 'コマンド' とする。-lでログインシェルとして動くようになる。shellscriptの場合#!/bin/bash -lに書いちゃえば良い
```
0 10-18 * * 1-5 /bin/bash -l -c '~/Desktop/time_signal/time.rb'
```
```
GOOGLE_APPLICATION_CREDENTIALS=~/job/creds/token.json
PATH=/usr/bin:/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
0 * * * * env > ~/cron.env
40 9 * * * pipenv run ~/job/daily.sh 2>> ~/job/cron.daily.log
```
また、cronでは実行する際のカレントディレクトリはホームディレクトリにセットされてしまうよう。なので注意。

cheetsheet
```sh
# 毎日24:00
0 0 * * * <Command>

# 毎時0分
0 * * * * <Command>

# 毎週月曜7:00
0 7 * * 1 <Command>

# 毎週金曜22:00
0 22 * * 5 <Command>

# 毎月1日の7:00
0 7 1 * * <Command>

#weekdayの 10-12月の 1日の 15:00から 1分おき に実行
* 15 1 10,11,12 1-5 ~/test/test.sh >> ~/log.log 2>&1 

```

### 並列で実行させる
```sh
echo arg1 app1_list.json arg2 app2.json | \
xargs -n2 -P 2 bash ./get_resource.sh  2>> cron_err.log
#上記の例は引数は2つづつ指定で2プロセスで実行
```
途中で停止した場合、停止したい場合の対応について要確認。trapとか？強制終了時などにバックグラウンドのプロセスを確実に停止させるため、trapで終了時の処理を設定しておきたい。  
https://soratobi96.hatenablog.com/entry/20190802/1564682602


### 正規表現の先読み、後読みとか (?<=hoge)foo(?!bar) みたいなの
https://qiita.com/tohta/items/2ba7ecde5636b38ef1f6   
**基本系が(?=regex)で、否定なら!にして、直前なら<を追加する。**　　
> macとかだとPerl風正規表現が使えないとそもそも利用できなそうなので、注意 GNU grepを入れる

- 肯定先読み
- 否定先読み
- 肯定後読み
- 否定後読み

|書き方	|意味|
| ---- | ---- |
|(?=regex)	|直後にregexが**ある**|
|(?!regex)	|直後にregexが**無い**|
|(?<=regex)	|直前にregexが**ある**|
|(?<!regex)|	直前にregexが**無い**|
```sh
例）
(?<=hoge)foo(?!bar) → 直前にhogeがあり、直後にbarが無いfooにマッチ
(?<!hoge)foo(?=bar) → 直前にhogeが無くて、直後にbarがあるfooにマッチ

#構文の中に丸括弧とかいろいろあるけど、マッチする箇所がfooだけなのが重要なところです。
#あと '(?〜'の中では正規表現は使えるが、*とか+とか繰り返し系は使えなそう
```

### 環境変数による切替で色んなパラメタで試せる(envdir)
scriptは環境変数を参照してるので環境変数を切り替えて実行できる.
```sh
pip install envdir 
envdir <env file> <cmd or script>
```
```
ex.) envdir ../env/sandbox01 ./shell_curl

env
│   ├── sandbox01
│   │   └── BASE_URL
│   ├── sandbox02
│   │   ├── APP_URL
│   │   ├── BASE_API_URL
│   │   ├── BASE_URL ...
```


### crypton で暗号処理
https://kauplan.org/books/serversetup/

```sh
#実行例:暗号化と復号を行うスクリプトを利用可能にする
base="serversetup-samplecode-2.0.tar.gz"
curl -O https://kauplan.org/books/serversetup/$base.tar.gz $ tar xf $base.tar.gz
cd $base/
chmod a+x chapter1/crypton
sudo cp chapter1/crypton /usr/local/bin
which crypton
#/usr/local/bin/crypton

# 実行例:スクリプト「crypton」の使い方
### パスワードファイルを置くディレクトリを作成
sudo mkdir -m 700  ̃/secret

### 環境変数にパスワードファイル名を設定
export PASSWORD_FILE= ̃/secret/pass1
sudo ls $PASSWORD_FILE # パスワードファイルがないのを確認 
# ls: cannot access ’ ̃/secret/pass1...


### パスワードファイルを生成
crypton -g
sudo ls $PASSWORD_FILE /home/yourname/secret/pass1
cat $PASSWORD_FILE
# cat: /home/yourname/secret/pass1: Permission denied

crypton -P # パスワードが表示されるはず
### 暗号化
crypton -e file1.txt file2.txt
### 復号
crypton -d file*.txt.encrypted
```

### ディレクトリ移動

- cd する前のディレクトリに戻るだけなら、「cd -」を使う。 
- cd を何度かしたあとに戻る必要があるなら、
  - サブシェルを使うか、
  - pushd と popd を使う(ただし sh では使用不可)。
