return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local opts = { noremap = true, silent = true }

      -- Find files including hidden ones
      vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files hidden=true<cr>', opts)

      -- List open buffers
      vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<cr>', opts)
    end
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup ({
        start_in_insert = true
      })

      -- Key mappings should be defined outside the setup function
      vim.keymap.set('n', '<Leader>tt', ':ToggleTerm direction=float<cr>')
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:ToggleTerm<cr>')
    end
  },
  {
    "echasnovski/mini.files",
    opts = {
      windows = {
        preview = true,
      },
      mappings = {
        go_in_plus = "l",
        go_in = "L",
        close = "q", -- 追加: qでウィンドウを閉じる
      },
      options = {
        follow_current_file = true,
      },
      content = {
        filter = function(file)
          -- Function to check if a value exists in a table
          local function table_contains(table, value)
            for _, v in ipairs(table) do
              if v == value then
                return true
              end
            end
            return false
          end

          -- Files to ignore
          local ignored_files = {
            ".DS_Store",
          }

          -- Split the file path
          local t = vim.fn.split(file.path, "/")
          local file_name = t[#t]

          -- Return true if the file is not in the ignored list
          return not table_contains(ignored_files, file_name)
        end,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      vim.keymap.set('n', '<leader>e', ':lua require("mini.files").open()<cr>', { noremap = true, silent = true })
    end,
  },
  {
    "echasnovski/mini.cursorword",
    config = function(_, opts)
      require('mini.cursorword').setup(opts)
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
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }
    end
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  }
}
