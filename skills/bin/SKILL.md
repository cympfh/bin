---
name: mybin
description: |
  `~/bin` にある個人用 CLI スクリプトの用途・使い方・依存関係を案内するスキル。
  ユーザーが `~/bin` のコマンド、パイプライン、API 設定、またはスクリプトの追加・更新について尋ねたら必ず使用する。
  実ファイルと対応コマンドの `--help` を優先し、この一覧は補助情報として扱う。
---

# mybin

`~/bin` は Python、Bash、Ruby の個人用 CLI 集です。コマンドの詳細は実装と、
対応している場合の `コマンド --help` を確認し、この一覧と挙動が違う場合は実装を正としてください。

## 使い方の指針

- 対象コマンドの実ファイルを確認してから、必要なら副作用のない `--help` を実行してください。
- API、認証情報、外部サーバー、WSL、Docker など環境依存の条件を明示してください。
- ファイル変更、外部 API への書き込み、通知、デバイス操作、プレイリスト削除などを伴う場合は、実行前に対象と副作用を説明してください。
- stdin/stdout のパイプに対応するコマンドと、対話的・ファイル引数専用のコマンドを区別してください。

## AI / LLM

| コマンド | 用途 |
| --- | --- |
| `codegen` | xAI でコード生成（`chat`）と `{{ }}` プレースホルダー補完（`complete`）。`-L`、`-m`、`-r`、`-w`、`-o` を使う。 |
| `translate` | xAI で翻訳し、検出言語・訳文・中国語の拼音を JSON で出力する。`-s` / `-t` で言語を指定する。 |
| `zhcomp` | 中国語を簡体字に修正し、拼音と日本語訳を JSON で出力する。 |
| `zplay` | 日本語・拼音・中国語を正規化し、中国語音声を gTTS で生成して mplayer で再生する。`-s`、`--no-play` に対応する。 |
| `ocr` | 画像ファイルまたは URL を OCR し、OCR 結果・説明・要約・タグを JSON で出力する。 |
| `aidoc` | Markdown を CSS/JavaScript 込みの HTML に変換する。`-p`、`-m`、`-r`、`-o` に対応する。 |
| `igrok` | `grok-imagine-image-2.0` で画像を生成・編集する。`-i`、`-o`、`-a`、`-r` を使う。 |
| `eliza` | Eliza サーバーの `chat` / `summary` API を呼び出す。通常は `localhost:9096`、停止時は外部ホストを探す。 |

`codegen`、`translate`、`zhcomp`、`ocr`、`aidoc`、`zplay` は `XAI_API_KEY` を
使います。既定モデルは `grok-4.7` で、推論量の既定値は `codegen` と `aidoc` が `medium`、
それ以外のチャット系ツールが `low` です。`igrok` は画像 API の固定モデルを使います。

```bash
codegen chat -L Python "フィボナッチ数列を計算する関数を書いて"
echo 'def fib(n): {{ implement }}' | codegen complete
translate -s en -t ja "How are you?"
zhcomp "你好"
zplay --no-play "你好"
ocr screenshot.png
aidoc README.md -o README.html
igrok '犬のイラストを描いて' -o dog.png
```

## システム・一般ユーティリティ

| コマンド | 用途・注意 |
| --- | --- |
| `withcache` | コマンドの成功した stdout を TTL キャッシュする。コマンドと引数を別々に渡す。`-t 1h` などを使う。 |
| `weasel` | ファイル変更または時刻（`--at` / `--after`）を監視し、`--cmd` を実行する。`--loop` で反復する。 |
| `clip` | Linux / WSL / macOS のクリップボードを操作する。`-i FILE` はコピー、`-o FILE` は貼り付け。 |
| `notify` | notify-send、terminal-notifier、WSL の BurntToast を切り替えて通知する。 |
| `progressbar` | `create` / `update` / `done` で端末プログレスバーを表示する。 |
| `gen-password` | `/dev/urandom` からランダムなパスワードを生成する。 |
| `name` | ランダムな形容詞＋名詞の名前を生成する。`--no-adj` で形容詞を省く。 |
| `run` | 拡張子に応じて Python、Ruby、JavaScript、Rust のソースを直接実行する。 |
| `etmp` | `$EDITOR` で `~/Dropbox/memo/etmp.md` を開く。 |
| `open-browser` | WSL の候補ブラウザーまたは `$BROWSER` で URL / ファイルを開く。 |
| `paste-stream` | クリップボードの変化を監視し、変化した内容を stdout に出す。 |
| `ipwin` | WSL から Windows の IPv4 アドレスを取得する。 |
| `pwait` | プロセス名が終了するまで待つ。`-n` は回数、`-i` は間隔。 |
| `updatedb` | 利用可能な `locate.updatedb` / `updatedb` を実行する。 |
| `venv` | `venv new`、`venv clear`、`venv clean` で `.venv` を作成・削除・再作成する。削除に注意する。 |
| `winclock` | WSL2 で Windows 側の時刻を使って Linux の時計を設定する。`sudo` が必要。 |
| `colors256` | ANSI 16色・256色・24bit 色を端末に表示して確認する。 |
| `shuf` | ファイルまたは stdin の行をシャッフルする。 |
| `next` | 画像の実体に合わせて拡張子を変更する。ファイル名を変更する。 |
| `ren` | ファイル内容の MD5 でファイル名を変更する。ファイル名を変更する。 |
| `diffminus` | 第1ファイルにあり、第2ファイルにない行を出力する。 |
| `rsa` | SSH 公開鍵で stdin を RSA 暗号化し、または秘密鍵で復号する。 |

```bash
withcache -t 1h curl https://example.com/
weasel --cmd "make test" src/
clip -i README.md
progressbar create --total 100
progressbar update --total 100 --count 50
printf '行1\n行2\n' | shuf
```

## メディア・画像・文書

| コマンド | 用途・注意 |
| --- | --- |
| `aeg` | 固定 URL の音声を `/tmp/aeg.wav` に取得して mplayer で再生する。 |
| `amesh` | 東京アメッシュの降雨レーダー画像を取得する。`-A` でアニメーション、`--label` で時刻を付ける。 |
| `beamer` | Markdown を pandoc で Beamer TeX に変換し、`latex` でビルドする。pandoc と Docker が必要。 |
| `eye` | TOML のメタデータを使って MP3 の ID3 タグとカバーを設定する。`-f FILE`、`-n`（dry-run）を使う。 |
| `feh-marking` | feh の画面で画像をマーク / 解除し、マーク済みのパスを出力する。対話操作が必要。 |
| `fix-mp4` | MP4 を再エンコードして `<name>_fixed.mp4` を作る。 |
| `imagediff` | 2画像の知覚ハッシュを比較し、違えば終了コード 1 にする。 |
| `imagehash` | 画像の pHash と aHash を出力する。 |
| `imagick` | ImageMagick のレベル調整・拡大縮小を行う。`level60` / `level70` / `level80` / `x0.5` / `x2` / `x4`、および `ai` がある。 |
| `pixelart` | 画像を指定ブロックサイズでピクセル化する。`-p` でサイズを指定する。 |
| `taiju` | 外部サーバーへ体重を記録し、履歴を gnuplot で描画する。`memo` は書き込みを伴う。 |
| `tex2img` | TeX 断片を PNG に変換する。出力に `-` を指定すると stdout に出す。 |
| `latex` | Docker の TeX Live で `.tex` を PDF に変換する。 |
| `visplot` | JSONL の数値ログを Visdom で描画する。`-y` が必須で、Visdom が必要。 |
| `zip-del` | zip 内の項目を peco で選び、`zip -d` で削除する。破壊的なので対象を確認する。 |

```bash
imagick x2 image.png
pixelart -p 12 input.png output.png
tex2img formula.tex formula.png
eye -n -f metadata.toml
visplot -y temperature log.jsonl
```

## Web・データ・外部サービス

| コマンド | 用途・注意 |
| --- | --- |
| `tenki` | OpenWeatherMap で現在の天気や予報を取得する。`-f` / `--full` / `--tomorrow`、`--icon` / `--emoji` に対応する。 |
| `html-title` | URL または stdin の HTML から `<title>` を抽出する。 |
| `html-encode` | HTML エンティティを encode / decode する。decode は `-d`。 |
| `json2yaml` | stdin の JSON を YAML に変換する。 |
| `yaml2json` | stdin またはファイルの YAML を JSON に変換する。 |
| `toml2json` | stdin またはファイルの TOML を JSON に変換する。 |
| `uri-encode` | URI を encode / decode する。decode は `-d`。 |
| `http-status` | HTTP ステータスコードまたは語句から意味を検索する。 |
| `toqr` | テキスト / URL を QR コードにする。`-o` で出力先を指定する。 |
| `doujin-search` | Melonbooks から同人誌と頒布イベントを検索する。 |
| `danbooru-tags` | Danbooru の画像 URL からタグを抽出する。`web-grep` が必要。 |
| `danbooru-tags-complete` | Danbooru のタグ候補と投稿数を検索する。 |
| `usdjpy` | 為替サイトから USD/JPY の bid / ask を取得する。 |
| `kubelogs` | Pod 名の正規表現に一致する Kubernetes Pod のログを取得する。 |
| `slacktee` | stdin の内容を Slack チャンネルへ送る。トークンは `~/.slackcat`、`-N` は dry-run。 |
| `switchbot` | SwitchBot のデバイス・エアコン・照明・シーンを操作する。API トークンと秘密鍵が必要。 |
| `youtube` | YouTube Data API v3 の検索、OAuth、プレイリスト操作を行う。 |
| `youtube-search` | `youtube search` の互換ラッパー。 |
| `x-dlp` | Firefox の cookies を渡して `yt-dlp` を実行する x.com 向けラッパー。ローカルのブラウザプロファイルに依存する。 |

```bash
tenki --tomorrow Tokyo
echo '<title>Test</title>' | html-title
echo '{"key":"value"}' | json2yaml
toqr -o qr.png 'https://example.com'
youtube search -n 10 --order date 'Python tutorial'
youtube playlist list
youtube-search --json 'keyword'
```

### 外部サービスの設定

- `switchbot`: `SWITCHBOT_API_TOKEN` と `SWITCHBOT_API_SECRET` を設定する。
- `youtube`: 検索には `YOUTUBE_API_KEY`、OAuth には `~/.config/youtube/client.json` または `YOUTUBE_CLIENT_ID` / `YOUTUBE_CLIENT_SECRET` を使う。認証後の token は `~/.config/youtube/token.json` に保存し、`YOUTUBE_REFRESH_TOKEN` でも代替できる。設定場所は `XDG_CONFIG_HOME` に従う。
- `slacktee`: Slack token を `~/.slackcat` に置く。送信前に `slacktee -N CHANNEL` で payload を確認する。
- `eliza`、`taiju`、`doujin-search`、`danbooru-tags*`、`amesh`、`tenki`、`usdjpy` はネットワークアクセスを行う。

## 時刻・テキスト・VRChat

| コマンド | 用途・使い方 |
| --- | --- |
| `jdate` | 外部サイトから日の出・日の入りを取得し、時刻に応じた日本の不定時法を表示する。`jdate debug` は固定値で検証する。 |
| `timer` | 引数なしで経過時間を表示する。Ctrl-C で終了する。 |
| `calendar` | `-f FILE` のカレンダー定義を表示する。`-A` / `-B`、`--color`、`--html` を使う。 |
| `jinja2` | Jinja2 テンプレートを処理する。変数は `-e key=value` で渡す。 |
| `filename` | ファイル名の各要素を表示する。`-B` / `-R` / `-D` / `-E` / `-T`、未指定時は JSON。 |
| `pinyin` | pypinyin で中国語を拼音へ変換する。引数または stdin を受け取る。 |
| `playspell` | Weblio の発音 MP3 を取得して mplayer で再生する。 |
| `vrchatbox` | VRChat の OSC Chatbox にメッセージを送る。stdin、`-L`、`-q`、`-v`、`-N` に対応する。 |
| `vrchatosc` | VRChat OSC の宛先と引数を指定して UDP メッセージを送る。`i:` / `f:` / `b:` の型接頭辞を使う。 |

```bash
calendar -f calendar.txt -A 30 --color
echo '中心' | pinyin
jinja2 template.j2 -e name=World
echo 'こんにちは' | vrchatbox --dry-run
```

## 記述を更新するとき

コマンドの追加・削除・オプション変更時は、次を確認してこのファイルを更新してください。

1. `rg --files` と実行権限からコマンドの現状を確認する。
2. `コマンド --help`、ソース、`pyproject.toml` を照合する。
3. API キー、依存コマンド、ネットワーク、ファイル変更などの前提条件を記載する。
4. 破壊的・外部書き込みを伴う例には注意書きを付ける。
