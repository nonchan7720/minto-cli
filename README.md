# minto-cli

[MinTo](https://mintoai.net/) 静的サイトホスティングサービスの公式CLIです。
デプロイ、サイト管理、課金、お問い合わせフォームの作成までターミナルから行えます。

## できること

- **デプロイ**: ディレクトリやzipを指定するだけでサイトを公開
- **サイト管理**: サイトの作成・更新・削除・一覧
- **課金管理**: プランの購入やStripeカスタマーポータルの利用
- **AIエージェント連携**: Claude Code などにMinToの操作方法を学習させるスキルを配布（お問い合わせフォームの作成にも対応）

## インストール

[Releases](https://github.com/nonchan7720/minto-cli/releases) から OS/アーキテクチャに合ったバイナリをダウンロードし、PATHの通った場所に配置してください。

```bash
minto-cli --help
```

## クイックスタート

```bash
# 1. ログイン（ブラウザが開きます）
minto-cli login

# 2. サイトを作成
minto-cli sites create --name "My App" --subdomain myapp

# 3. ビルド結果をデプロイ
minto-cli deploy ./dist

# 4. デプロイ状況を確認
minto-cli status <deployment_id>
```

`--site-id` などのIDを省略すると、対話形式で選択できます（ターミナルで実行している場合）。

## コマンド一覧

| コマンド | 説明 |
| --- | --- |
| `minto-cli login` | ブラウザ経由でログインし、トークンを保存 |
| `minto-cli deploy <path>` | ディレクトリ / zip をデプロイ |
| `minto-cli status <deployment_id>` | デプロイ状況を確認 |
| `minto-cli sites list` | サイト一覧を表示 |
| `minto-cli sites create` | サイトを新規作成 |
| `minto-cli sites update` | サイト情報を更新 |
| `minto-cli sites delete` | サイトを削除 |
| `minto-cli billing checkout` | 課金プランのチェックアウトを開始 |
| `minto-cli billing portal` | Stripeカスタマーポータルを開く |
| `minto-cli skills` | AIエージェント向けスキルをプロジェクトにインストール |

各コマンドの詳しいオプションは `minto-cli <command> --help` で確認できます。

### グローバルフラグ

| フラグ | デフォルト | 説明 |
| --- | --- | --- |
| `--server` | `https://api.mintoai.net` | 接続先のMinTo APIサーバー |
| `--token` | (保存済みトークン) | 認証トークン（未指定時は `minto-cli login` で保存したものを使用） |

## AIエージェント向けスキル / MCPサーバー

本リポジトリは Claude Code などのAIエージェントが会話だけでMinToの操作（デプロイ・サイト管理・
課金・お問い合わせフォーム作成）を代行できるようになる **Agent Skill** と、フォームの作成・管理を
行う **MCPサーバー接続設定** をあわせて公開しています。

- **デプロイ / サイト管理 / 課金**: 各コマンドをどう呼び出せばよいかをエージェントに教えます
- **お問い合わせフォームの作成・管理**: 「問い合わせフォームを付けて」のような依頼から、フォームの設計・サイトへの埋め込み・再デプロイまでを一気に行えるようになります（MinToのMCPサーバーが提供する `form_create` などのツールを使用）

### プラグインとしてインストール（推奨・Claude Code）

スキルとMCPサーバー接続をまとめてセットアップできます。MinToのMCPサーバーはOAuth2に対応しているため、
初回利用時にClaude Codeがブラウザでのサインインを自動的に案内します。

```shell
/plugin marketplace add nonchan7720/minto-cli
/plugin install minto@minto
```

接続先を本番以外にしたい場合は、インストール時に `MinTo API サーバー URL`（`server_url`）を変更してください。

### スキル単体でのインストール（Claude Code以外 / `gh skills` など）

プラグイン形式に対応していないツールでも、[`skills/minto/SKILL.md`](skills/minto/SKILL.md) を
スキル単体として参照・インストールできます。

```jsonc
// 例: skills-lock.json
{
  "version": 1,
  "skills": {
    "minto": {
      "source": "nonchan7720/minto-cli",
      "sourceType": "github"
    }
  }
}
```

手動で使う場合は `skills/minto/SKILL.md` をそのままプロジェクトの `.claude/skills/minto/SKILL.md`
（または各ツールが参照するスキルディレクトリ）にコピーしてください。この方法ではMCPサーバー接続は
含まれないため、フォーム作成にはプラグインとしてのインストールが必要です。
