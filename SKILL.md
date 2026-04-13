---
name: mybin
description: |
  ~/bin/ は PATH に通された個人用ユーティリティスクリプト集（65+個, Python/Bash/Ruby）。
  AI/LLM連携、システムユーティリティ、メディア処理、Web/データ操作、開発ツールをカバー。
  全スクリプトは Unix パイプ対応（stdin/stdout）、詳細な使い方は各コマンドの --help で確認できる。
---

> **Note:** 各コマンドの詳細な使い方・オプションは `コマンド名 --help` で確認できます。

## AI/LLM Tools

### codegen

LLMでコード生成・`{{ }}` プレースホルダー補完。xAI/Gemini/OpenAI/Anthropic対応。

```bash
codegen chat "フィボナッチ数列を計算する関数を書いて"
echo 'def fib(n): {{ implement }}' | codegen complete
codegen chat -p gemini -m gemini-2.0-flash "..."
```

### translate

多言語翻訳（自動言語検出）。中国語の場合はピンイン付き。

```bash
echo "Hello world" | translate
translate -t ja "How are you?"
translate -f en -t zh "Hello"
```

### zhcomp

中国語テキスト修正・ピンイン変換・日本語翻訳。

```bash
echo "中国語テキスト" | zhcomp
zhcomp --pinyin "你好"
zhcomp --ja "中文"
```

### pinyin

中国語テキストをピンインに変換する。

```bash
pinyin "中心"
echo "中心" | pinyin
```

### ocr

画像ファイルからテキストを抽出する。

```bash
ocr screenshot.png
ocr image.jpg
```

### igrok

xAI Grok API を使った画像生成・編集 CLI。テキストプロンプトから画像を生成し、既存画像を編集できる。

```bash
igrok '犬のイラストを描いて' -o dog.png
igrok '猫に変換' -i dog.png -o cat_edited.png
```

### eliza

Claude API を使ったチャット CLI。会話履歴管理とサマリー作成機能付き。

```bash
eliza chat "こんにちは、今日の天気は？"
eliza summary
```

### youtube-search

YouTube Data API v3 を使った動画検索（結果を5分キャッシュ）。

```bash
youtube-search "猫 かわいい"
youtube-search -n 10 --order date "Python tutorial"
youtube-search --json "keyword"
```

## System Utilities

### withcache

コマンド結果を TTL 付きでキャッシュし、再実行を防ぐ。

```bash
withcache --ttl 3600 "curl https://api.example.com/data"
withcache "slow-command"
```

### weasel

ファイル監視＆時間ベースのコマンド自動実行。

```bash
weasel --watch src/ --exec "make test"
weasel --at "14:00" --exec "backup.sh"
```

### clip

クロスプラットフォーム（Linux/WSL/macOS）クリップボード操作。

```bash
echo "text" | clip    # コピー
clip                  # ペースト
```

### notify

デスクトップ通知を送る。

```bash
notify "タスク完了"
long-task && notify "Done!"
```

### progressbar

ターミナルにプログレスバーを表示する。

```bash
progressbar --total 100 --current 50
```

### gen-password

ランダムなパスワードを生成する。

```bash
gen-password
```

### name

形容詞＋名詞のランダムな名前を生成する。

```bash
name
name --no-adj
```

### run

任意のスクリプト/ソースコードファイルを直接実行する（shebang不要）。

```bash
run script.py
run code.rb
```

### usdjpy

現在の USD/JPY 為替レートを表示する（ライブ取得）。

```bash
usdjpy
```

### switchbot

SwitchBot API を使ってスマートホームデバイスを操作する。

```bash
switchbot devices               # デバイス一覧
switchbot status <device_id>    # デバイス状態取得
switchbot light <device_id> on  # ライトをON
switchbot aircon <device_id>    # エアコン操作
switchbot scene <scene_id>      # シーン実行
```

## Media & Graphics

### imagediff

2枚の画像の差分を検出・比較する。

```bash
imagediff before.png after.png
imagediff --output diff.png image1.png image2.png
```

### imagehash

画像の知覚ハッシュを生成する（重複検出・類似判定に使用）。

```bash
imagehash image.png
imagehash *.jpg
```

### pixelart

ピクセルアート画像を処理する。

```bash
pixelart image.png
```

### amesh

amesh.jp から最新の天気レーダー画像を取得する。

```bash
amesh
```

## Web & Data Processing

### tenki

OpenWeatherMap API を使って天気情報を取得する。

```bash
tenki
tenki Tokyo
```

### html-title

HTMLコンテンツや URL から title タグを抽出する。

```bash
echo "<html><head><title>Test</title></head></html>" | html-title
```

### html-encode

HTML エンティティのエンコード/デコードを行う。

```bash
echo "<div>" | html-encode
html-encode --decode "&lt;div&gt;"
```

### json2yaml / yaml2json / toml2json

データフォーマットを相互変換する。

```bash
echo '{"key": "value"}' | json2yaml
echo 'key: value' | yaml2json
toml2json pyproject.toml
```

### uri-encode

URL エンコード/デコードを行う。

```bash
echo "hello world" | uri-encode
uri-encode --decode "hello%20world"
```

### http-status

HTTP ステータスコードの意味を調べる。

```bash
http-status 404
http-status 200
```

### toqr

テキストや URL から QR コードを生成する。

```bash
echo "https://example.com" | toqr
toqr --output qr.png "text"
```

### doujin-search

同人誌を検索する。

```bash
doujin-search "keyword"
doujin-search -v "keyword"
```

## Time & Date Tools

### jdate

日本のカレンダー情報・日の出日の入り時刻を計算する。

```bash
jdate
jdate 2024-01-01
```

### timer

カウントダウンタイマー・ストップウォッチ。

```bash
timer 60
timer --stopwatch
```

### calendar

拡張カレンダー表示。

```bash
calendar
calendar 2024 12
```

## Development & Text Processing

### jinja2

Jinja2 テンプレートをコマンドラインで処理する。

```bash
echo "Hello {{ name }}" | jinja2 --var name=World
jinja2 template.j2 --var key=value
```

### filename

ファイル名の操作・サニタイズを行う。

```bash
echo "My File.txt" | filename --sanitize
```

## Configuration

### llm-config

codegen/translate/zhcomp などの AI ツール向け LLM 設定を管理する。

```bash
llm-config --list
llm-config --set provider=gemini
llm-config --set model=grok-4-fast-reasoning
```
