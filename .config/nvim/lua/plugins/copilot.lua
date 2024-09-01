return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = { yaml = true }
      local keymap = vim.keymap.set
      -- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
      keymap("i", "<C-g>", 'copilot#Accept("<CR>")',
        { silent = true, expr = true, script = true, replace_keycodes = false })
      keymap("i", "<C-j>", "<Plug>(copilot-next)")
      keymap("i", "<C-k>", "<Plug>(copilot-previous)")
      keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
      keymap("i", "<C-s>", "<Plug>(copilot-suggest)")
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        model = "gpt-4o",  -- Set model to gpt-4o
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          layout = 'float',
          width = 0.8,
          height = 0.8,
          -- popup = {
          --   border = "rounded",  -- Use a rounded border for the popup
          --   winblend = 10,       -- Set transparency
          --   highlight = "NormalFloat", -- Set highlight group for the floating window
          -- },
          -- popup = {
          --   size = { height = "55%", width = "55%" },
          --   position = "50%",
          -- },
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      -- -- Show help actions with telescope
      -- { "<leader>ad", M.pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
      -- -- Show prompts actions with telescope
      -- { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
      -- New key mappings
      {
        "<leader>at",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>ae",
        function()
          return require("CopilotChat").explain()
        end,
        desc = "Explain with CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>ar",
        function()
          return require("CopilotChat").review()
        end,
        desc = "Review with CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>af",
        function()
          return require("CopilotChat").fix()
        end,
        desc = "Fix with CopilotChat",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      require("CopilotChat.integrations.cmp").setup()

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
