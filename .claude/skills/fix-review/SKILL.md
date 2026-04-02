---
name: fix-review
description: PRのレビューコメントを取得し、指摘事項を修正する
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Agent
---

現在のブランチに紐づくPRのレビューコメントを取得し、指摘事項を修正してください。

## 手順

1. 以下を並列で実行して現在の状態を把握する
   - `git branch --show-current` で現在のブランチ名を取得
   - `gh pr list --head <ブランチ名> --json number,title,url` で紐づくPRを特定
   - `git status` で未コミットの変更を確認

2. PRのレビューコメントを取得する
   - `gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews` でレビュー一覧を取得
   - `gh api repos/{owner}/{repo}/pulls/{pr_number}/comments` でインラインコメントを取得
   - `gh pr view {pr_number} --comments` でPR全体のコメントも確認

3. レビューコメントを分析する
   - 未解決の指摘事項をリストアップする
   - 各指摘が対象とするファイル・行番号を特定する
   - 指摘の種類を分類する（バグ修正、リファクタリング、スタイル、質問等）

4. 指摘事項の一覧をユーザーに提示し、どれを対応するか確認する

5. 承認された指摘事項を修正する
   - 対象ファイルを読み込み、コンテキストを理解してから修正する
   - 修正後、変更内容をユーザーに報告する

## 注意事項

- 質問形式のコメント（「なぜこうしたのか？」等）は修正ではなく、ユーザーに回答案を提示する
- 修正の意図が不明な指摘は、ユーザーに確認してから対応する
- `git commit` や `git push` は実行しない（ユーザーが別途行う）
- 複数のPRが見つかった場合は、どのPRか確認する
