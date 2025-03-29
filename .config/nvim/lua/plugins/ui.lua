return {
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      notifier = {
        timeout = 1000,
      },
      input = {}
    },
    keys = {
      {
        "<leader>nh",
        function()
          require("snacks.notifier").show_history()
        end,
        desc = "Notify",
      },
    },
  },
  {
    "romgrk/barbar.nvim",
    vent = "BufReadPost",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "BufReadPost",
    opts = {},
  },
  {
    "echasnovski/mini.cursorword",
    event = "BufReadPost",
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          "dashboard",
        },
      },
    },
  },
  {
    "echasnovski/mini.diff",
    event = "BufReadPost",
    opts = {},
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay(0)
        end,
        desc = "Toggle mini.diff overlay",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "BufReadPost",
    opts = {
      file_types = { "markdown", "copilot-chat" },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    event = "BufReadPost",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = ".",
        },
      },
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "ColorizerToggle" },
    opts = {
      "*",
    },
    {
      "vinnymeller/swagger-preview.nvim",
      event = "BufReadPost",
      cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
      build = "npm i",
      config = true,
      opts = {
        port = 8000,
        host = "localhost",
      },
      keys = {
        {
          "<leader>sp",
          "<cmd>SwaggerPreview<cr>",
          desc = "SwaggerPreview",
        },
      },
    },
  },
}
