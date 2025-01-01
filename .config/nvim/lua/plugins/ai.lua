return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_filetypes = { yaml = true }
      local keymap = vim.keymap.set
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true --   { silent = true, expr = true, script = true, replace_keycodes = false })
      keymap("i", "<C-j>", "<Plug>(copilot-next)")
      keymap("i", "<C-k>", "<Plug>(copilot-previous)")
      keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
      keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
      keymap('i', '<C-L>', '<Plug>(copilot-accept-word)')
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    event = "VeryLazy",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4o",
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          layout = 'float',
          width = 0.8,
          height = 0.8,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
        chat_autocomplete = true
      }
    end,
    keys = {
      { "<c-s>",      "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>cc", "",     desc = "+ai",        mode = { "n", "v" } },
      {
        "<leader>cc",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ccx",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cct",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>cce",
        function()
          return require("CopilotChat").explain()
        end,
        desc = "Explain with CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>ccr",
        function()
          return require("CopilotChat").review()
        end,
        desc = "Review with CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>ccf",
        function()
          return require("CopilotChat").fix()
        end,
        desc = "Fix with CopilotChat",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
 }
}
