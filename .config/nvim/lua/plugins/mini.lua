return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
    end,
  },
  {
    "echasnovski/mini.files",
    opts = {
      windows = {
        preview = true,
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 60,
      },
      mappings = {
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        open_split = 's',
        open_vsplit = 'v',
        reset = '<BS>',
      },
      options = {
        use_icons = true,
        follow_current_file = true,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      -- Key mappings for toggling and buffers, similar to Neotree
      vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { noremap = true, silent = true })
    end,
  },
  {
    "echasnovski/mini.comment",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.comment").setup {
        mappings = {
          comment = "<Leader>/",
          comment_line = "<Leader>/",
          comment_visual = "<Leader>/",
          textobject = "<Leader>/",
        },
      }
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup()
    end,
  },
}
