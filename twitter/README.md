# ターミナルの中でTwitterを完結させたい

## 必要

- bash or zsh
    - 以下の2つのツール以外はありあわせのシェルスクリプトで頑張ろう
- twurl: https://github.com/twitter/twurl
    - TwitterAPIをコマンドラインから叩くツール
- jq: http://stedolan.github.io/jq/
    - jsonテキストを整形、射影するツール
- 以上に自然にパスが通っていること

1. `./bin/` にパスを通す

`./bin` 以下には一つのTwitter API を `twurl` で叩いて
`jq` で整形して表示するだけのシェルスクリプトがいくつか置いてある  
この文書のこれより以下ではそのシェルスクリプトの使い方を説明する

## ツイートする: `tw`

1引数を取ってテキストとしてツイートする  
引数が与えられなかった場合、標準入力から read する

```bash
$ tw hoge hoge # post "hoge hoge"
$ date | tw # post $(date)
```

```bash
$ tw
a b
c  d
^D # post "a b\nc  d"
```

### vim からツイートする

バッファ全体を、あるいは選択した状態で選択した行をツイート

```vim
:w !tw
```

### ツイートする窓

```bash
rlwrap sh -c 'while read a; do tw "$a"; done'
```

一行入力する度にツイートするコマンド  
終了は Ctrl-D とか

## 画像つきでツイートする: `tw-media` `tw-url`

### tw-media
ローカルにある画像つきでツイートする

```bash
tw-media 'てきすと' '画像のパス'
```

### tw-url
画像のurlを指定して画像付きでツイートする

```bash
tw-media 'てきすと' '画像のURL'
```

`/tmp/` に `wget` で一回保存してるだけなので,
サーバによっては弾かれる

## 画像つきでリプライする: `tw-rep-url`

画像のurlを指定して画像付きでリプライをする

```bash
tw-rep-url '相手のユーザ名 (screen_name)' 'リプライ先のstatus_id' '画像のURL'
```

## アカウントの管理

### 新しいアカウントの追加 (認証): `tw-auth`

個人的に取得したアプリケーションの
`consumer key/secret`
をすでに埋めた状態にある

一般には `$TWURL authorize` で行う

### ツイートするアカウントの確認: `tw-ls`

```bash
tw-ls
```

### ツイートするアカウントの変更: `tw-cd`

```bash
tw-cd '別なアカウントのユーザ名 (screen_name)'
```

## ユーザーのプロフィールを見る

`screen_name` として `cympfh` を適用する例

```bash
twurl /1.1/users/show.json?screen_name=cympfh | jq .
```

## タイムラインの取得、表示

### ホームタイムライン: `tw-home`
### メンションタイムライン: `tw-mentions`
### DMタイムライン: `tw-dms`

```bash
$ cat ./bin/tw-home
#!/bin/bash

twurl -X GET /1.1/statuses/home_timeline.json?count=199 | jq -r 'reverse | .[] | "\u001b[33m\(.user.name) \u001b[91m@\(.user.screen_name) \u001b[34m\(.id_str)\n  \u001b[37m\(.text)\u001b[0m"'
```

`jq` を使って適当に色をつけて表示してるだけ  
`tw-mentions` は `tw-home` のurlが異なっているだけ  
`tw-dms` は帰ってくるJSONの構造がちょい違う


## UserStream: `tw-stream`

ところで、ホームタイムラインについては UserStream を使うのが普通だろう

```bash
$ tw-stream
延々とタイムラインが流れる
なんか何度もこのAPI叩いてるとストリームも切れやすくなる気がする？
```

```bash
$ cat ./bin/tw-stream
#!/bin/sh

twurl -t -A 'Accept-Encoding: text' -H userstream.twitter.com /1.1/user.json 2>/dev/null | grep --line-buffered '^{' | jq -r 'if has("text") then "\u001b[33m\(.user.name) \u001b[91m@\(.user.screen_name) \u001b[34m\(.id_str)\n  \u001b[37m\(.text)\u001b[0m" else "" end'
```

`-t` オプションで、バッファを逐次出力させる  
受け取ったJSON以外の生データ (compressed gzip) とかいろいろ併せて出力させるけど
`grep '^{'`
でたぶんJSONだけ表示出来ている  
あとは `jq` でいい感じに表示するだけ

## 本郷の天気 `tw-tenki`

本郷の天気をツイートする

# Future Work

- UserStream 全部で通してマージできるかな
- 全部のアカウントのメンション、タイムラインの取得、マージ

