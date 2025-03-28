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
    }
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
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      stages = "static",
      presets = {
        lsp_doc_border = true,
        command_palette = true,
        long_message_to_split = true,
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
        },
        signature = {
          enabled = true,
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
        },
      },
    },
    keys = {
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },

      {
        "<leader>nt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
    },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
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
