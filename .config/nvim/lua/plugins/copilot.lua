return {
  {
    "github/copilot.vim",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      prompts = {
        Commit = {
          prompt = "> #git:staged\n\n"
              .. "以下の形式で日本語のコミットメッセージを生成してください：\n"
              .. "形式: <Prefix>: <理由>、<変更内容>\n\n"
              .. "要件：\n"
              .. "1. Prefix（必須）は以下から選択：\n"
              .. "   - feat: 新しい機能\n"
              .. "   - fix: バグの修正\n"
              .. "   - docs: ドキュメントのみの変更\n"
              .. "   - style: 空白、フォーマット、セミコロン追加など\n"
              .. "   - refactor: 仕様に影響がないコード改善(リファクタ)\n"
              .. "   - perf: パフォーマンス向上関連\n"
              .. "   - test: テスト関連\n"
              .. "   - chore: ビルド、補助ツール、ライブラリ関連\n\n"
              .. "2. メッセージの構成：\n"
              .. "   - 「〇〇なため、△△を追加/修正/変更」の形式\n"
              .. "   - 理由（なぜその変更が必要か）を必ず含める\n"
              .. "   - 変更内容は具体的に記述\n\n"
              .. "3. 記述のポイント：\n"
              .. "   - コードレビューがしやすいように具体的に\n"
              .. "   - 変更の意図が明確に伝わるように\n"
              .. "   - 将来のメンテナンスを考慮した説明を含める\n\n"
              .. "メッセージは gitcommit コードブロックで囲んでください。\n",
        },
      },
    },
  },
}