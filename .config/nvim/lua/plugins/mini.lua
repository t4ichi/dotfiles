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
      require('mini.pairs').setup(opts)
    end,
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
    "echasnovski/mini.comment",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mini.comment").setup {
        mappings = {
          comment = "<leader>/",
          comment_line = "<leader>/",
          comment_visual = "<leader>/",
          textobject = "<leader>/",
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
  {
    "echasnovski/mini.cursorword",
    config = function(_, opts)
      require('mini.cursorword').setup(opts)
    end,
  },
}
