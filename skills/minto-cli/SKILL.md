---
name: minto-cli
description: MinTo CLI (minto-cli) — MinTo 静的サイトホスティングのデプロイ・サイト管理・課金・ステータス確認・お問い合わせフォーム作成を行うCLI/MCPツール。
---

# MinTo CLI (minto-cli)

MinTo の静的サイトホスティングサービスを管理するコマンドラインツールです。

## 前提条件

### インストール

```bash
# ビルド済みバイナリを使用
minto-cli --help
```

### 認証

```bash
# ブラウザを使用してログイン (OAuth 2.1 PKCE)
minto-cli login

# トークンは ~/.minto/token に保存されます（24時間有効）
```

## コマンド一覧

### デプロイ

```bash
# ディレクトリをデプロイ（対話的にサイト選択）
minto-cli deploy ./dist

# zipファイルをデプロイ
minto-cli deploy ./build.zip

# サイトIDを指定してデプロイ
minto-cli deploy ./dist --site-id <UUID>
```

### デプロイステータス確認

```bash
minto-cli status <deployment_id>
```

### サイト管理

```bash
# サイト一覧
minto-cli sites list

# チームを指定してサイト一覧
minto-cli sites list --team-id <UUID>

# サイト作成（対話的入力）
minto-cli sites create

# サイト作成（フラグ指定）
minto-cli sites create --name "My Site" --subdomain mysite --team-id <UUID>

# サイト更新（対話的入力）
minto-cli sites update

# サイト更新（フラグ指定）
minto-cli sites update --site-id <UUID> --name "New Name"

# サイト削除（対話的にサイト選択）
minto-cli sites delete

# サイト削除（サイトID指定）
minto-cli sites delete --site-id <UUID>
```

### 課金管理

```bash
# Stripe チェックアウトセッションを開く（対話的）
minto-cli billing checkout

# プランを指定してチェックアウト
minto-cli billing checkout --org-id <UUID> --plan essential

# Stripe カスタマーポータルを開く
minto-cli billing portal
minto-cli billing portal --org-id <UUID>
```

## フォーム作成・管理（MCP）

お問い合わせ/申し込みフォームの作成・管理は `minto-cli` の CLI コマンドではなく、
MinTo の MCP サーバー（`/mcp`）が提供する MCP ツールで行います。MinTo に MCP 接続した
状態で、ユーザーの会話的な依頼（例:「問い合わせフォームを付けて」）からフィールド構成を
設計し、以下のツールを呼び出してください。

| ツール | 用途 |
| --- | --- |
| `form_create` | サイトにフォームを新規作成し、埋め込み用HTMLスニペット（`embed_snippet`）を取得 |
| `form_update` | 既存フォームの定義（フィールド・通知先・自動返信）を全体置換で更新 |
| `form_delete` | フォームと受信済みの回答をすべて削除（元に戻せない） |
| `form_list` | サイトのフォーム一覧と `form_id` を取得 |
| `form_submissions_list` | フォームが受け取った問い合わせ（回答）を新しい順に取得。`since` で期間絞り込み可 |
| `form_submission_thread` | 1件の問い合わせについて、訪問者の回答〜オーナーとのメールのやり取り全履歴を取得（読み取り専用） |

### 典型的なフロー

1. `form_create` でフィールド（text/email/textarea/select など）・`notify_emails`・
   必要なら `auto_reply` を指定してフォームを作成する。定義は MinTo のフォーム定義
   JSON Schema（ツールの入力スキーマに埋め込み済み）でバリデーションされる。
2. レスポンスの `embed_snippet`（自己完結型の HTML+JS）を、ユーザーが指定した位置の
   サイトの HTML に貼り付ける。
3. `minto-cli deploy` でサイトを再デプロイして反映する。

```bash
# 3. フォームを埋め込んだサイトを再デプロイ
minto-cli deploy ./dist --site-id <UUID>
```

### 注意点

- フォームの表示項目を変更した場合（`form_update`）は、返却される新しい
  `embed_snippet` で旧スニペットを置き換えてから再デプロイすること。
  `notify_emails` / `auto_reply` のみの変更は再デプロイ不要。
- 問い合わせへの返信は MCP からは送信できない（読み取り専用）。オーナーは通知メールに
  返信するだけでよく、MinTo が双方向にメールをリレーする。
- `form_delete` を実行したら、対象サイトの HTML から埋め込みスニペット
  （`<!-- MinTo Form: ... -->` ブロックと `<script>`）を削除して再デプロイすること。

## 重要: CLIフラグを優先使用すること（非TTY環境向け）

**minto-cli の対話モードは TTY (端末) を必要とします。**
Claude Code のような非TTY環境では対話モードは動作しません。
**常に CLIフラグを直接指定してください。**

### 非TTY環境での必須パターン

```bash
# デプロイ: --site-id を必ず指定
minto-cli deploy ./dist --site-id <UUID>

# サイト作成: --name --subdomain --team-id を必ず指定
minto-cli sites create --name "My Site" --subdomain mysite --team-id <UUID>

# サイト更新: --site-id を必ず指定
minto-cli sites update --site-id <UUID> --name "New Name"

# サイト削除: --site-id を必ず指定
minto-cli sites delete --site-id <UUID>

# サイト一覧: --team-id を必ず指定
minto-cli sites list --team-id <UUID>

# 課金チェックアウト: --org-id と --plan を必ず指定
minto-cli billing checkout --org-id <UUID> --plan essential

# 課金ポータル: --org-id を必ず指定
minto-cli billing portal --org-id <UUID>
```

> フラグを省略すると対話的な番号入力を求められますが、
> 非TTY環境では stdin の EOF によりエラーになります。
> 先に `minto-cli sites list --team-id <UUID>` でIDを確認してから使用してください。

## グローバルフラグ

| フラグ     | デフォルト                | 説明                   |
| ---------- | ------------------------- | ---------------------- |
| `--server` | `https://api.mintoai.net` | MinTo API サーバー URL |
| `--token`  | (保存済みトークン)        | JWT 認証トークン       |

## 典型的なワークフロー

```bash
# 1. ログイン
minto-cli login

# 2. サイトを作成（初回のみ）
minto-cli sites create --name "My App" --subdomain myapp

# 3. ビルド結果をデプロイ
minto-cli deploy ./dist

# 4. デプロイ状態を確認
minto-cli status <deployment_id>
```
