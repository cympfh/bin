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
```

## アーキテクチャ

### スクリプト構成

- `./bin/{FILE}` - メインスクリプト（直接実行可能）
- `./bin/external/{FILE}` - 外部コマンドのダウンロードスクリプト
- `./bin/stuff/{FILE}` - ダウンロードされた外部コマンド

### 主要なツール分類

#### AI/NLP関連

- `zhcomp` - 中国語テキスト修正・ピンイン変換（OpenAI API使用）
- `translate` - 多言語翻訳（OpenAI API使用）
- `codegpt`, `papergpt` - ChatGPT系ツール

#### システム・ユーティリティ

- `weasel` - ファイル監視・時間ベースコマンド実行（watchgod使用）
- `withcache` - コマンド結果キャッシング（TTL対応）
- `clip` - クリップボード操作
- `progressbar` - プログレスバー表示

#### メディア・グラフィック

- `amesh` - 天気レーダー画像取得
- `imagediff`, `imagehash` - 画像処理
- `feh-marking` - 画像マーキング

### 共通パターン

#### Pythonスクリプトの特徴

- `click` ライブラリによるCLI実装
- 型アノテーション完備
- `rich` による美しいログ出力
- 標準入力からのテキスト読み込み対応（`sys.stdin.read()`）
- `--help` / `-h` フラグによるヘルプ表示

#### OpenAI API使用ツール

- 環境変数 `OPENAI_API_KEY` が必要
- JSON形式での構造化レスポンス
- gpt-4o / gpt-4o-mini モデル選択可能

## 使用方法

全てのスクリプトは `-h` または `--help` フラグでヘルプを表示できます。

PATH設定例:

```bash
export PATH=$PATH:/home/cympfh/bin
export PATH=$PATH:/home/cympfh/bin/external
export PATH=$PATH:/home/cympfh/bin/stuff
```
