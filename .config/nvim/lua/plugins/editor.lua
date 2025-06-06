return {
  {
    "simonmclean/triptych.nvim",
    event = "BufReadPost",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "antosha417/nvim-lsp-file-operations",
    },
    opts = {
      options = {
        show_hidden = true,
      }
    },
    keys = {
      { "<leader>e", "<cmd>Triptych<CR>" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true,
        ignore_patterns = { "node_modules/", ".git/", "dist/", "build/" },
      },
      lazygit = {},
      image = {}
    },
    keys = {
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files" },
      { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent" },
      -- grep
      { "<leader>fg", function() Snacks.picker.grep() end,                                    desc = "Grep" },
      -- lazygit
      { "<leader>lg", function() Snacks.lazygit() end,                                        desc = "LazyGit" },
      -- git
      { "<leader>gf", function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
    }
  },
  {
    "folke/trouble.nvim",
    event = "BufReadPost",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    event = "BufReadPost",
    opts = {},
    keys = {
      { "<leader>ho", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Open DiffView against HEAD~1" },
      { "<leader>hh", "<cmd>DiffviewFileHistory<CR>", desc = "Open DiffView File History" },
      { "<leader>hc", "<cmd>DiffviewClose<CR>",       desc = "Close DiffView" },
      {
        "<leader>hm",
        "<cmd>DiffviewOpen origin/main...HEAD<CR>",
        desc = "Open DiffView against origin/main...HEAD",
      },
      {
        "<leader>hd",
        "<cmd>DiffviewOpen origin/develop...HEAD<CR>",
        desc = "Open DiffView against origin/develop...HEAD",
      },
      {
        "<leader>hf",
        "<cmd>DiffviewOpen origin/frontend...HEAD<CR>",
        desc = "Open DiffView against origin/frontend...HEAD",
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
