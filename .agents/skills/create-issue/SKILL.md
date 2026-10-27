---
name: create-issue
description: TaskunのGitHub Issueを作成し、承認後にTaskun Projectへの追加と指定されたStatus・Labelの設定を行う。
---

# GitHub Issueの作成

既存の `AGENTS.md` を最優先する。対象リポジトリは `koguchi-e/Taskun`、追加先Projectは `koguchi-e` が所有する `Taskun Project`（Project #3）とする。GitHub CLIでProjectを操作する場合は `--owner koguchi-e` を指定する。既存Issueを無断で変更・削除しない。

## 事前確認

1. 現在のGitリポジトリの `nameWithOwner` が `koguchi-e/Taskun` と一致することと、`AGENTS.md` を確認する。一致しない場合は外部変更を中止する。GitHub CLIを使う場合は、Issueの検索・作成・Label設定に `--repo koguchi-e/Taskun` を指定する。GitHub連携ツールを使う場合も、対象リポジトリを明示する。
2. 依頼内容から検索語を抽出し、既存Issueを検索して類似・重複を確認する。重複候補がない場合はIssue案の作成へ進む。候補がある場合は候補を提示してユーザーに確認し、既存Issueとの重複と確認された場合は新規Issueを作成せず終了する。重複でないと確認された場合だけIssue案の作成へ進む。
3. 指定されたLabel、Status、Projectが存在するか確認する。存在しない設定がある場合は、ユーザーが有効な値を指定するまでIssue作成を開始しない。存在しないLabelやStatusを勝手に作成しない。指定がない場合も推測して設定しない。

## Issue案の作成

タイトルと本文は日本語で作成する。本文には次の見出しを含め、各節をMarkdownリストで記載する。

```markdown
## 概要

- このIssueが必要な理由と経緯

## 作業内容

- 実施する変更

## 完了条件

- 完了を判断できる条件
```

## 承認と作成

Issue作成、Projectへの追加、Status・Labelの設定は外部変更である。実行直前に、次の内容をユーザーへ提示して明示的な承認を得る。

- Issueのタイトルと本文
- 追加先Project
- 設定するStatusとLabel
- 類似・重複Issueの検索結果

承認後は、GitHub CLIまたはGitHub連携ツールで次の順に実行する。

1. Issueを一度だけ作成し、Issue番号とURLを取得する。
2. IssueをTaskun Project（Project #3）に追加する。
3. ユーザー指定のStatusとLabelだけを設定する。

Issue作成後にProject追加や設定が失敗した場合は、同じIssueを再作成しない。作成済みIssueのURL、完了した設定、失敗した操作を報告して停止する。Issue作成自体が失敗または成否不明な場合も、再試行前に既存Issueを検索し、重複がないことを確認する。

## 報告

作成後は、IssueのURL、Projectへの追加結果、Status、Label、実行結果を報告する。
