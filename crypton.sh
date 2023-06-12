#!/bin/sh

##
## @(#) opensslコマンドでファイルを暗号化/復号する。
##
## 特徴：
##   * ファイル「A.txt」を暗号化して「A.txt.encrypted」を生成し、
##     ファイル「A.txt.encrypted」を復号して「A.txt」を生成する。
##   * パスワードをパスワードファイルから自動的に読み込むので、
##     長いパスワードを使用しても使い勝手が悪くならない。
##     （短いパスワードが使われるのを防ぐのに有効。）
##   * パスワードファイルが置かれているディレクトリは、root ユーザ
##     のみアクセス可能とする（それ以外でも読み出せるならエラー）。
##     そのため、sudo できるユーザのみがパスワードを取得可能。
##   * 要 openssl コマンド。
##
## 事前準備：
##   $ sudo mkdir      ~/secret      # パスワードファイルを置く場所
##   $ chmod 700       ~/secret      # 所有者以外のアクセスを禁止
##   $ sudo chown root ~/secret      # 所有者を root ユーザに変更
##   ### または sudo mkdir -m 700 ~/secret だと上の3つが一度でできる
##   $ PASSWORD_FILE=~/secret/pass1  # パスワードファイル名
##   $ export PASSWORD_FILE          # 環境変数に設定
##   $ sudo ls $PASSWORD_FILE        # パスワードファイルがないのを確認
##   ls: cannot access '~/secret/pass1': No such file or directory
##   $ crypton -g                    # パスワードファイルを生成
##   $ sudo ls $PASSWORD_FILE        # パスワードファイルができたのを確認
##   /home/yourname/secret/pass1
##   $ cat $PASSWORD_FILE            # 一般ユーザはアクセス不可なのを確認
##   cat: /home/yourname/secret/pass1: Permission denied
##   $ crypton -P                    # パスワードが表示されるはず
##
## 使い方：
##   $ crypton -e file1 file2...       # ファイルを暗号化
##   $ crypton -d file1.encrypted ...  # ファイルを復号
##
## オプション：
##   -h     : ヘルプメッセージを表示
##   -e     : ファイルを暗号化（例：A.txt → A.txt.encrypted）
##   -d     : ファイルを復号  （例：A.txt.encrypted → A.txt）
##   -x     : 入力ファイル（-e）または暗号化ファイル（-d）を削除
##   -g     : パスワードファイルを生成する（'-G 50' 相当）
##   -G N   : パスワードの長さを指定してパスワードファイルを生成
##   -c     : 標準出力に出力
##   -C     : パスワードファイルをチェック（検証）する
##   -p     : パスワードを端末から読み取る（ファイルからではなく）
##   -P     : パスワードファイルからパスワードを読みこんで表示
##   -q     : 出力を抑制する
##

set -e      # スクリプトにエラーがあれば終了
set -u      # 未定義の変数があればエラーにする

## openssl コマンドのオプションを指定
## （OpenSSL 1.1 との互換性のため、-md sha256 をつける）
OPENSSL_OPTION="-aes-256-cbc -salt -md sha256"

## グローバル変数
quiet_mode=''       # 出力を抑制する（空ならコマンドを表示）
pw_length=50        # デフォルトのパスワードの長さ

## エラーメッセージを出力して終了
abort () {
  echo "Error: $1" >&2
  exit 1
}

## コマンドを表示してから実行する
run () {
  [ -z "$quiet_mode" ] && echo "$ $1" >&2
  eval "$1"
}

## ヘルプメッセージを表示
print_help () {
  cat <<HERE
Preparation:
  $ mkdir           ~/secret    # create password directory
  $ chmod 700       ~/secret    # allow access only by owner
  $ sudo chown root ~/secret    # change owner to root user
  ## or: sudo mkdir -m 700 ~/secret  # same as above commands
  $ export PASSWORD_FILE=~/secret/pass1
  $ crypton -g                  # create password file
  $ sudo ls -l \$PASSWORD_FILE   # confirm password file generated

Usage:
  $ crypton -e file1 file2...       # encrypt files
  $ crypton -d file1.encrypted ...  # decrypt files

Options:
  -h      : print help
  -e      : encrypt files (ex: A.txt -> A.txt.encrypted)
  -d      : decrypt files (ex: A.txt.encrypted -> A.txt)
  -x      : remove plain file (when -e) or encrypted file (when -d)
  -g      : generate password file (same as '-G ${pw_length}')
  -G N    : take password length and generate password file
  -c      : output to stdout
  -C      : check (validate) password file
  -p      : read password from tty (instead of password file)
  -P      : show password and exit
  -q      : quiet mode
HERE
}

## コマンドオプションを検証
validate_command_options () {
  local argc=$1 e=$2 d=$3 x=$4 g=$5 G=$6 c=$7 C=$8 P=$9
  if [ -n "$G" ]; then   # -G の引数は正の整数を期待
    if ! echo "$G" | grep -qE '^[0-9]+$'; then
      abort "-G $G: integer (>=1) expected."
    fi
    [ "$G" -gt 0 ] || abort "-G $G: expected >=1."
    return
  fi
  [ -n "$g" ] && return
  [ -n "$C" ] && return
  [ -n "$P" ] && return
  if [ -z "$e" -a -z "$d" ]; then
    abort "-e (encrypt) or -d (decrypt) required."
  fi
  if [ -n "$e" -a -n "$d" ]; then
    abort "-e (encrypt) and -d (decrypt) are mutually exclusive."
  fi
  if [ -n "$c" -a -n "$x" ]; then
    abort "-c (to stdout) is not available with -x (remove input file)."
  fi
  if [ "$argc" -eq 0 ]; then
    [ -n "$e" ] && abort "-e: plain file required."
    [ -n "$d" ] && abort "-d: encrypted file required."
  fi
}

## パスワードファイルが置かれているディレクトリを検証する関数
check_password_dir () {
  local dir=$1
  ## ディレクトリがなければエラー
  [ -d "$dir" ] || abort "$dir: directory not exist"
  ## シンボリックリンクならセキュリティの懸念があるためエラー
  [ -L "$dir" ] && abort "$dir: should not be symbolic link."
  ## 所有者が root ユーザでなければエラー
  set -- `sudo ls -ld $dir`
  local permission=$1 owner=$3
  [ "$owner" = "root" ] || abort "$dir: should be owned by root."
  ## 所有者である root ユーザ以外がアクセスできるならエラー
  case "$permission" in
  d*------) ;;   # ok
  *)  abort "$dir: non-root user can access to directory." ;;
  esac
}

## パスワードファイルを読み込む関数
read_password_file () {
  local pwfile pw
  ## 環境変数 $PASSWORD_FILE にパス名が設定されていること
  pwfile=${PASSWORD_FILE:-}
  [ -n "$pwfile" ] || abort '$PASSWORD_FILE should be set.'
  ## パスワードファイルを読み込む
  pw=`run 'sudo -p "(sudo) Password:" cat $PASSWORD_FILE'`
  ## パスワードファイルが置かれているディレクトリを検証
  check_password_dir `dirname $PASSWORD_FILE`
  ## チェックに通ったらパスワードを返す
  echo $pw
}

## 端末からパスワードを読み込む
read_password_from_tty () {
  local e=$1 d=$2 pw pw2
  stty -echo              # 入力したパスワードを表示させない
  if [ -n "$d" ]; then    # 復号用
    read -rp "Decryption Password:" pw; echo >&2
    stty echo
  elif [ -n "$e" ]; then  # 暗号化用
    read -rp "Encryption Password:" pw; echo >&2
    read -rp "Confirm Password:"   pw2; echo >&2  # パスワードを確認
    stty echo
    [ "$pw" = "$pw2" ] || abort "password not matched."
  else
    stty echo
    abort "(internal) unreachable"
  fi
  echo "$pw"
}

## パスワードファイルを生成する
generate_password_file () {
  local n=${1:-$pw_length} f=${PASSWORD_FILE:-} home dir
  ## 環境変数 $PASSWORD_FILE が未設定または空ならエラー
  [ -n "$f" ] || abort 'environ variable $PASSWORD_FILE required.'
  ## パスワードファイルが置かれているディレクトリが存在しないならエラー
  home=`echo ~`
  dir=`dirname $PASSWORD_FILE | sed -e "s!^$home/!~/!"`
  run 'sudo ls -ld `dirname $PASSWORD_FILE`' || \
    abort "$dir: password directory not exist.
    ## How to create password directory:
    $ sudo mkdir      $dir    # create password directory
    $ sudo chown root $dir    # change owner to root user
    $ sudo chmod 700  $dir    # deny access by non-root user
    ## Or
    $ sudo mkdir -m 700 $dir  # same as above commands"
  ## パスワードファイルが置かれているディレクトリを検証
  check_password_dir `dirname $PASSWORD_FILE`
  ## パスワードファイルがすでに存在しているなら上書きを防ぐためにエラー
  run 'sudo ls $PASSWORD_FILE 2>/dev/null' && \
    abort "$PASSWORD_FILE: password file exists; remove it at first."
  ## base64 形式のランダムな文字列を $n 文字分生成する
  ## （FreeBSD では base64 コマンドが標準ではインストールされてないので
  ##   head -c /dev/urandom | base64 ではなく openssl rand -base64 を
  ##   使う。ただし改行を含むことがあるので、tr -d "\n" で取り除く。）
  run "{ openssl rand -base64 $n | tr -d \"\\\\n\" | head -c $n;
    echo; } | sudo tee $f >/dev/null"  # echo は改行を追加するため
  run "sudo chown root $f"   # 所有者を root ユーザに変更
  run "sudo chmod 600  $f"   # 所有者 (root) のみアクセス可能に変更
}

## メイン処理
main () {
  ## 引数が何もないか、または '--help' なら、ヘルプメッセージを表示
  if [ $# -eq 0 -o ${1:-''} = '--help' ]; then
    print_help
    exit 0
  fi
  ## コマンドオプションを解析
  local opt h='' e='' d='' x='' g='' G='' c='' C='' p='' P='' q=''
  while getopts 'hedxgG:cCpPq' opt; do
    case $opt in
    h)  h='Y' ;;    # print help
    e)  e='Y' ;;    # encrypt action
    d)  d='Y' ;;    # decrypt action
    x)  x='Y' ;;    # remove input file (with -e/-d)
    g)  g='Y' ;;    # generate password file
    G)  G=$OPTARG;; # generate pw file with pw length
    c)  c='Y' ;;    # output to stdout
    C)  C='Y' ;;    # check (validate) password file
    p)  p='Y' ;;    # read password with prompt
    P)  P='Y' ;;    # show encryption password
    q)  q='Y' ;;    # quiet mode
    \?) exit 1;;
    esac
  done
  shift `expr $OPTIND - 1`
  ## -h オプションならヘルプメッセージを表示
  if [ -n "$h" ]; then
    print_help
    exit 0
  fi
  ## コマンドオプションをチェック
  validate_command_options $# "$e" "$d" "$x" "$g" "$G" "$c" "$C" "$P"
  quiet_mode=$q
  ## -g/-G オプションのときはパスワードファイルを生成する
  if [ -n "$g" -o -n "$G" ]; then
    generate_password_file "$G"
    return
  fi
  ## -C オプションのときはパスワードファイルを検証するだけ
  if [ -n "$C" ]; then
    read_password_file > /dev/null  # パスワードファイルを検証
    [ -n "$quiet_mode" ] || echo "[ok] $PASSWORD_FILE"
    return
  fi
  ## -p オプションのときはパスワードを端末から読み込み、
  ## そうでないときはパスワードファイルから読み込む
  if [ -n "$p" ]; then
    PASSWORD=`read_password_from_tty "$e" "$d"`
  else
    PASSWORD=`read_password_file`
  fi
  ## -P オプションのときはパスワードを表示して終了
  if [ -n "$P" ]; then
    echo $PASSWORD
    return
  fi
  ## opensslコマンドがパスワードを読み取れるよう、環境変数に設定
  export PASSWORD
  ## ファイルを暗号化または復号する
  local ext='encrypted'   # 暗号化ファイルの拡張子
  local openssl_opt="$OPENSSL_OPTION -pass env:PASSWORD"
  if [ -n "$e" ]; then    # 暗号化 (encrypt)
    for f in "$@"; do
      [ "${f%.$ext}" = "${f}" ] || abort "$f: already encrypted."
      if [ -n "$c" ]; then
        run "openssl enc -e $openssl_opt < $f"
      else
        run "openssl enc -e $openssl_opt < $f > $f.$ext"
        [ -z "$x" ] || run "rm $f"  # -x のとき平文ファイルを削除
      fi
    done
  elif [ -n "$d" ]; then  # 復号 (decrypt)
    for f in "$@"; do
      [ "${f%.$ext}" != "${f}" ] || abort "$f: not encrypted."
      if [ -n "$c" ]; then
        run "openssl enc -d $openssl_opt < $f"
      else
        run "openssl enc -d $openssl_opt < $f > ${f%.$ext}"
        run "chmod 600 ${f%.$ext}"  # 他人によるアクセスを防ぐ
        [ -z "$x" ] || run "rm $f"  # -x のとき暗号化ファイルを削除
      fi
    done
  else
    abort "(internal error) unreachable"
  fi
}

main $@
