return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    cmd = "CopilotChat",
    opts = {
      -- カスタムプロンプト
      prompts = {
        Commit = {
          prompt = "> #git:staged\n\n"
            .. "以下の形式で日本語のコミットメッセージを生成してください：\n"
            .. "形式: <Prefix>: <変更内容>\n\n"
            .. "要件：\n"
            .. "Prefix（必須）は以下から選択：\n"
            .. "   - feat: 新しい機能\n"
            .. "   - fix: バグの修正\n"
            .. "   - docs: ドキュメントのみの変更\n"
            .. "   - style: 空白、フォーマット、セミコロン追加など\n"
            .. "   - refactor: 仕様に影響がないコード改善(リファクタ)\n"
            .. "   - perf: パフォーマンス向上関連\n"
            .. "   - test: テスト関連\n"
            .. "   - chore: ビルド、補助ツール、ライブラリ関連\n\n",
        },
      },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
      {
        "<leader>aa",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "x" },
      },
      {
        "<leader>ax",
        function()
          require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "x" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({ prompt = "Quick Chat: " }, function(input)
            if input ~= nil and input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "x" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "x" },
      },
    },
  },
}
