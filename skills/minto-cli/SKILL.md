---
name: minto-cli
description: >
  Use this skill whenever the user asks how to use minto-cli commands, what flags are available,
  how to log in, deploy a site, create or update a site, check deployment status, or manage sites.
  Trigger on any mention of "minto", "minto-cli", "MinTo", or questions like "how do I deploy",
  "how do I create a site", "what are the minto commands", "minto login", "minto deploy", etc.
---

# minto-cli 使い方ガイド

minto-cli は MinTo 静的サイトホスティングサービスを操作するコマンドラインツールです。

## グローバルフラグ

すべてのコマンドで使えるフラグ:

| フラグ | デフォルト | 説明 |
|--------|-----------|------|
| `--server` | `https://api.mintoai.net` | API サーバー URL |
| `--token` | *(自動読み込み)* | JWT 認証トークン（省略時は `~/.minto/token` を使用） |

---

## login — ログイン

ブラウザを使った OAuth 2.1 PKCE 認証でログインします。トークンは `~/.minto/token` に保存され、以降のコマンドで自動的に使われます。

```bash
minto-cli login
minto-cli login --server https://your-server.example.com
```

**動作の流れ:**
1. ブラウザが自動で開きログインページへ
2. 認証完了後、ターミナルに戻ると自動でトークンが保存される
3. ブラウザが開かない場合は表示された URL を手動でコピーして開く

---

## create-site — サイト作成

新しいサイトを作成します。フラグを省略すると対話形式で入力できます。

```bash
# 対話形式
minto-cli create-site

# フラグで指定
minto-cli create-site \
  --name "My Blog" \
  --subdomain my-blog \
  --custom-domain blog.example.com \
  --basic-auth \
  --basic-auth-user admin \
  --basic-auth-password secret
```

| フラグ | 必須 | 説明 |
|--------|------|------|
| `--name` | ✅ | サイトの表示名 |
| `--subdomain` | ✅ | サブドメイン（例: `my-blog` → `my-blog.mintoai.net`） |
| `--custom-domain` | ➖ | 独自ドメイン |
| `--basic-auth` | ➖ | Basic 認証を有効化 |
| `--basic-auth-user` | ➖ | Basic 認証ユーザー名 |
| `--basic-auth-password` | ➖ | Basic 認証パスワード |

**成功時の出力例:**
```
Site created successfully!
Site ID:   019cea8a-e9d2-75de-b181-006e093aa7cc
Name:      My Blog
Subdomain: my-blog
```

カスタムドメインを設定した場合は DNS 設定に必要な TXT レコードと CNAME レコードも表示されます。

---

## deploy — デプロイ

ファイル（zip またはディレクトリ）をサイトへデプロイします。

```bash
# ディレクトリを指定（自動で zip に変換）
minto-cli deploy ./dist --site-id 019cea8a-e9d2-75de-b181-006e093aa7cc

# zip ファイルを直接指定
minto-cli deploy ./build.zip --site-id 019cea8a-e9d2-75de-b181-006e093aa7cc

# --site-id を省略するとサイト一覧から選択できる
minto-cli deploy ./dist
```

| フラグ | 必須 | 説明 |
|--------|------|------|
| `--site-id` | ➖ | デプロイ先サイトの UUID（省略時は一覧から選択） |

**引数:** `[archive_path]` — zip ファイルまたはディレクトリのパス（必須）

デプロイ中はアップロードの進捗バーとデプロイ状況がリアルタイムで表示されます。完了後に Deployment ID と Status が表示されます。

---

## sites — サイト管理

### sites list — サイト一覧

```bash
minto-cli sites list
```

Name・Subdomain・ID・Custom Domain・Status の一覧がテーブル形式で表示されます。

### sites delete — サイト削除

```bash
# サイト ID を指定
minto-cli sites delete --site-id 019cea8a-e9d2-75de-b181-006e093aa7cc

# 引数で指定
minto-cli sites delete 019cea8a-e9d2-75de-b181-006e093aa7cc

# 省略するとサイト一覧から選択できる
minto-cli sites delete
```

| フラグ | 説明 |
|--------|------|
| `--site-id` | 削除するサイトの UUID |

⚠️ 削除前に確認プロンプトが表示されます。関連するすべてのデプロイメントデータとファイルが削除されます。

---

## update-site — サイト設定更新

既存サイトの設定を変更します。フラグを省略すると対話形式で入力できます。

```bash
# 対話形式（サイト選択 → 変更項目を入力）
minto-cli update-site

# フラグで指定
minto-cli update-site \
  --site-id 019cea8a-e9d2-75de-b181-006e093aa7cc \
  --name "New Name" \
  --custom-domain new.example.com \
  --basic-auth \
  --basic-auth-user admin \
  --basic-auth-password newpassword
```

| フラグ | 説明 |
|--------|------|
| `--site-id` | 更新するサイトの UUID（省略時は一覧から選択） |
| `--name` | 新しいサイト名 |
| `--custom-domain` | 新しいカスタムドメイン |
| `--basic-auth` | Basic 認証の有効/無効 |
| `--basic-auth-user` | Basic 認証ユーザー名 |
| `--basic-auth-password` | Basic 認証パスワード |

変更したい項目だけ指定すれば OK です（未指定の項目は変わりません）。

---

## status — デプロイ状況確認

```bash
minto-cli status <deployment_id>
```

**例:**
```bash
minto-cli status abc12345-0000-0000-0000-000000000000
```

**出力例:**
```
Deployment ID: abc12345-0000-0000-0000-000000000000
Status:        deployed
Created At:    2026-03-18 10:00:00 +0000 UTC
```

Deployment ID は `deploy` コマンド実行後に表示されます。

---

## よくある使い方の流れ

```bash
# 1. ログイン
minto-cli login

# 2. サイトを作成
minto-cli create-site --name "My Site" --subdomain my-site

# 3. ビルド成果物をデプロイ
minto-cli deploy ./dist --site-id <作成時に表示された Site ID>

# 4. デプロイ状況を確認
minto-cli status <deploy 後に表示された Deployment ID>

# 5. サイト一覧を確認
minto-cli sites list
```
