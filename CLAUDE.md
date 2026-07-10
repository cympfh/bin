# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

このリポジトリは個人用のコマンドラインツール集（~/bin）です。主に以下の言語で作成されたスクリプトが含まれています：

- Python（メイン言語、uv + venvで管理）
- Shell/Bash
- Ruby

## 開発環境とコマンド

### Python環境

- Python 3.13+ 必須
- `uv` を使用してパッケージ管理（pyproject.toml、uv.lock）
- 仮想環境は `.venv/` に作成済み

### 型チェックとフォーマット

```bash
# 型チェック
pyright

# フォーマット
black .

# リンティング
ruff check
```

## アーキテクチャ

### スクリプト構成

- 実行可能スクリプト（65個）- 直接実行可能、拡張子なし
  - Python スクリプト（21個、32.3%）
  - Bash スクリプト（37個、56.9%）
  - Ruby スクリプト（6個、9.2%）
  - その他（1個、1.5%）

### 主要なツール分類

#### AI/NLP関連

- `codegen` - LLMによるコード生成・プレースホルダー補完（litellm使用、複数プロバイダー対応）
- `zhcomp` - 中国語テキスト修正・ピンイン変換（OpenAI API使用）
- `translate` - 多言語翻訳（xai_sdk使用）
- `igrok` - Grokによる画像生成・編集（xai_sdk使用、grok-imagine-imageモデル）
- `codegpt`, `papergpt` - ChatGPT系ツール
- `ocr` - OCR機能

#### システム・ユーティリティ

- `weasel` - ファイル監視・時間ベースコマンド実行（watchgod使用）
- `withcache` - コマンド結果キャッシング（TTL対応）
- `clip` - クリップボード操作（Linux/WSL/macOS対応）
- `progressbar` - プログレスバー表示
- `notify` - システム通知

#### メディア・グラフィック

- `amesh` - 天気レーダー画像取得
- `imagediff`, `imagehash` - 画像処理
- `feh-marking` - 画像マーキング
- `pixelart` - ピクセルアート処理
- `eye` - MP3メタデータ管理

#### Web・データ処理

- `tenki` - 天気情報（OpenWeatherMap API）
- `switchbot` - SwitchBot API連携
- `html-title`, `html-encode` - HTML処理
- `json2yaml`, `yaml2json`, `toml2json` - フォーマット変換
- `danbooru-tags-complete` - Danbooruタグ補完

#### 時間・日付ツール

- `jdate` - 日本のカレンダー・日の出日の入り計算
- `timer` - 時間計測
- `calendar` - 拡張カレンダー機能

#### 開発・テキスト処理

- `jinja2` - テンプレート処理
- `filename` - ファイル名ユーティリティ
- `uri-encode` - URL エンコーディング

### 共通パターン

#### Pythonスクリプトの特徴

- `click` ライブラリによるCLI実装
- 型アノテーション完備（モダンな `str | None` 構文使用）
- `rich` による美しいログ出力
- 標準入力からのテキスト読み込み対応（`sys.stdin.read()`）
- `--help` / `-h` フラグによるヘルプ表示
- パイプライン対応設計

#### クロスプラットフォーム対応

- クリップボード操作: xsel/pbcopy/PowerShell（WSL）の自動検出
- 日付処理: GNU/BSD dateコマンドの差異対応
- パス処理: Unix/Windows パス対応（WSL環境考慮）

#### API連携パターン

- 環境変数による設定管理（`OPENAI_API_KEY` など）
- 適切な認証処理（OAuth, HMAC-SHA256 for SwitchBot）
- ネットワークエラーハンドリング
- レスポンスキャッシュ機能

#### LLM/API使用ツール

大半のLLMツールは `litellm` を使用し、複数プロバイダー対応（xAI, Gemini, OpenAI, Anthropic）:

- `codegen`: コード生成・プレースホルダー補完
  - デフォルト: xai/grok-build-0.1（コード特化モデル）
  - `chat` サブコマンド: 自然言語からコード生成
  - `complete` サブコマンド: `{{ }}` プレースホルダー補完
- `zhcomp`: 中国語テキスト修正・ピンイン変換
  - 簡体字修正、ピンイン出力、日本語翻訳

共通仕様（litellm使用ツール）:
- `llm-config` コマンドで設定管理
- 構造化出力（Pydantic BaseModel + `response_format`）
- `-p/--provider` と `-m/--model` オプションでモデル選択可能

`translate` と `igrok` は例外で `xai_sdk` を直接使用（xAI専用、`XAI_API_KEY` 環境変数で認証）:
- `translate`: 多言語翻訳、自動言語検出、中国語の場合はピンイン付き
  - `-m/--model`（デフォルト: grok-4.3）と `-r/--reasoning-effort`（none/low/high）のみ指定可能、`-p/--provider` オプションはない
- `igrok`: `client.image.sample()` で画像生成・編集（モデル固定: grok-imagine-image）
  - `-i/--input` 指定時は画像編集モード（Data URI変換して送信）、未指定時は画像生成モード
  - `-o/--output` 必須、`-a/--aspect-ratio`（1:1/3:4/4:3/9:16/16:9、デフォルト1:1、生成時のみ）
  - レスポンスの画像URLをダウンロードして保存

## 使用方法

全てのスクリプトは `-h` または `--help` フラグでヘルプを表示できます。

PATH設定例:

```bash
export PATH=$PATH:/home/cympfh/bin
```
