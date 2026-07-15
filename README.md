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

## AIエージェント向けスキル

```bash
minto-cli skills
```

プロジェクトに `.agents/skills/minto-cli/SKILL.md` を作成します（`.claude/` があれば `.claude/skills/minto-cli` へのリンク作成も選べます）。これにより Claude Code などのAIエージェントが、会話だけでMinToの操作を代行できるようになります。

- **デプロイ / サイト管理 / 課金**: 各コマンドをどう呼び出せばよいかをエージェントに教えます
- **お問い合わせフォームの作成・管理**: 「問い合わせフォームを付けて」のような依頼から、フォームの設計・サイトへの埋め込み・再デプロイまでを一気に行えるようになります
