---
name: commit
description: 変更内容を分析してコミットメッセージを作成し、コミットする
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob
---

ステージされた変更と未ステージの変更を確認し、適切なコミットメッセージを作成してコミットしてください。

## 手順

1. `git status` と `git diff`（ステージ済み＋未ステージ）を確認
2. `git log --oneline -10` で直近のコミットメッセージのスタイルを確認
3. 変更内容を分析して、簡潔なコミットメッセージを作成
4. 関連ファイルをステージングしてコミット

## コミットメッセージのルール

- Conventional Commits 形式を使う: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `style:`, `test:`
- 1行目は50文字以内、日本語でも英語でもリポジトリの慣例に合わせる
- 必要に応じて本文に詳細を記述（空行を挟む）

## 注意事項

- `.env`、credentials、秘密鍵などのファイルはコミットしない
- `git push` は絶対に実行しない
- 変更がない場合はその旨を報告する
