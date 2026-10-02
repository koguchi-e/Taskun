# Taskun Docker化の調査・導入記録

調査日: 2026-09-30

## 現状

| 項目 | 内容 |
| --- | --- |
| Ruby | 3.1.2p20 |
| Rails | 6.1.7.10 |
| Bundler | 2.6.7 |
| Node.js | リポジトリ内の固定指定なし |
| Yarn | v1形式の `yarn.lock`。Dockerでは1.22.22を使用 |
| 開発・テストDB | SQLite3 (`db/development.sqlite3`, `db/test.sqlite3`) |
| 本番DB | MySQL（production設定のみ） |
| JavaScript | Webpacker 5.4.4、Webpack 4.46.0、Bootstrap 4、jQuery、Turbolinks |
| テスト | RSpec（model/system）、Minitestファイルも一部存在 |

- 既存のDockerfile、Compose、`.dockerignore` はなかった。
- 開発時のAction Cableはasyncアダプタのため、Redisは不要である。
- `bin/setup` と `bin/rails` は `ruby.exe` を参照するため、Linuxコンテナでは直接使用しない。
- Rails 6.1.7.10とlockされた `concurrent-ruby 1.3.5` の組み合わせではlogger読込順の問題が発生する。Dockerでは `RUBYOPT=-rlogger` で回避する。
- Alpineを採用したため、Bundlerはlockfileに `x86_64-linux-musl` のプラットフォームを追加する。Gemのバージョンは変更しない。

## Docker構成

開発用はSQLiteを維持する `web` サービス1つである。MySQL・Redisコンテナは追加しない。

```text
localhost:13000
  -> taskun_dev / web (Rails/Puma :3000)
       Ruby 3.1.2, Node.js 16.20.2, Yarn 1.22.22
       SQLiteはTaskun作業ツリー内のGit管理外DBファイルを利用
```

- Composeプロジェクト名: `taskun_dev`
- 公開ポート: `127.0.0.1:13000:3000`
- named volume: `taskun_dev_bundle`、`taskun_dev_node_modules`
- `docker compose down -v`、`docker volume prune`、既存Dockerリソースへの操作は行わない。

## 開発手順

```sh
docker compose build
docker compose run --rm web bundle exec rails db:prepare
docker compose up
```

ブラウザで `http://localhost:13000` を開く。テストは次の順で実行する。

```sh
docker compose run --rm -e RAILS_ENV=test web bundle exec rails db:prepare
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

停止時はVolumeを残す。

```sh
docker compose down
```

SMTPを使う場合は `.env.example` を複製してGit管理外の `.env` に `MAIL_ADDRESS` と `MAIL_PASSWORD` を設定する。

## CodexでIssue #40からPR作成まで進める方法

1. GitHub CLIの認証を確認する。未認証なら利用者自身が `gh auth login` を実行する。トークンをチャットに貼らない。

   ```sh
   gh auth status
   ```

2. Issue #40を確認し、Docker化の目的、対象範囲、完了条件、検証手順を必要に応じて追記する。Issue編集は外部状態を変更するため、本文を確認してから行う。
3. Codexに、Ruby/Railsを更新せず、SQLiteを維持し、Taskun専用のCompose名・ポート・VolumeでDockerfile、Compose、`.dockerignore`、`.env.example`、READMEを追加するよう依頼する。
4. Docker build、開発DB準備、テストDB準備、RSpec、Rails起動とHTTP応答を検証する。
5. `git diff --check` と差分レビューで秘密情報、SQLite DB、`node_modules`、意図しないlockfile更新がないことを確認する。
6. `feature/dockerize-development` ブランチへコミットする。
7. GitHubへpushし、`main` 向けのPRを作成する。PR本文には `Closes #40`、実施内容、Ruby/Railsを更新していないこと、検証結果、既存Dockerリソースを操作していないことを記載する。

Codexへの依頼例:

```text
Issue #40を確認してTaskunの開発環境Docker化を実装してください。
Ruby 3.1.2とRails 6.1.7.10は更新せず、開発DBはSQLiteのままにしてください。
Taskun専用のCompose名、Volume、ホストポートを使い、既存Dockerリソースは変更・削除しないでください。
Dockerfile、compose.yaml、.dockerignore、.env.example、READMEを追加し、build、DB準備、RSpec、Rails起動を検証してください。
Issue編集、push、PR作成の直前には対象と内容を報告して承認を待ってください。
```

## 検証結果

- Dockerfileの直接ビルド: 成功
- コンテナ内のバージョン: Ruby 3.1.2p20、Yarn 1.22.22、Rails 6.1.7.10
- logger回避設定後の `bundle exec rails -v`: 成功
- development SQLiteの `bundle exec rails db:prepare`: 成功
- test SQLiteの `bundle exec rails db:prepare`: 成功
- Rails起動と `http://127.0.0.1:13000/` のHTTP応答: 成功
- RSpec: 24例中11例成功、13例失敗。既存system specのボタン・リンク文言の期待値と実画面の不一致であり、Docker起因の起動・依存関係エラーではない。
