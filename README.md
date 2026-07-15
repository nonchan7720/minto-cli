# minto-cli

[MinTo](https://github.com/nonchan7720/minto) 静的サイトホスティングサービスのコマンドラインクライアントです。
デプロイ・サイト管理・課金操作に加えて、AIエージェント（Claude Code など）向けの操作スキルを配布します。

バイナリのソースおよびリリース定義は [nonchan7720/minto](https://github.com/nonchan7720/minto) の
`pkg/cmd/minto-cli` にあり、本リポジトリはビルド済みバイナリの配布（GitHub Releases）先です。

## インストール

[Releases](https://github.com/nonchan7720/minto-cli/releases) から OS/アーキテクチャに合ったバイナリをダウンロードしてください。

```bash
minto-cli --help
```

## 基本コマンド

```bash
# ログイン（ブラウザでOAuth 2.1 PKCE）
minto-cli login

# サイトへデプロイ
minto-cli deploy ./dist --site-id <UUID>

# サイト管理
minto-cli sites list --team-id <UUID>
minto-cli sites create --name "My Site" --subdomain mysite --team-id <UUID>

# 課金
minto-cli billing checkout --org-id <UUID> --plan essential
```

## AIエージェント向けスキル

```bash
minto-cli skills
```

現在のディレクトリに `.agents/skills/minto-cli/SKILL.md` を作成し、`.claude/` が存在する場合は
`.claude/skills/minto-cli` へのシンボリックリンク作成を確認します。これにより Claude Code などの
AIエージェントが minto-cli の操作方法を理解できるようになります。

スキルには以下が含まれます。

- **デプロイ / サイト管理 / 課金**: `minto-cli` の各コマンドをCLIフラグ付きで呼び出す方法（非TTY環境向け）
- **お問い合わせフォーム作成・管理**: MinTo の MCP サーバーが提供する `form_create` / `form_update` /
  `form_delete` / `form_list` / `form_submissions_list` / `form_submission_thread` ツールを使って、
  会話的な依頼（例:「問い合わせフォームを付けて」）からフォームを設計・埋め込み・再デプロイするフロー

スキルの内容は [nonchan7720/minto](https://github.com/nonchan7720/minto) の
`pkg/cmd/client/templates/SKILL.md` で管理されています。
