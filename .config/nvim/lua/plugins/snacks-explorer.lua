return {
  "folke/snacks.nvim",
  opts = {
    explorer = { enabled = true },
    picker = {
      sources = {
        explorer = {
          tree = true,
          follow_file = true,
          auto_close = true,
          focus = "list",
          hidden = true,
          git_status = true,
          git_status_open = true,
          diagnostics = true,
          diagnostics_open = true,
          watch = true,
          layout = {
            preset = "default",
            preview = true,
            backdrop = 60,
            position = "center",
            win = {
              style = "minimal",
              border = "rounded",
              title = " Explorer ",
              title_pos = "center",
              width = 0.8,
              height = 0.8,
              row = 0.1,
              col = 0.1,
            },
            preview_position = "right",
            preview_width = 0.5,
          },
          formatters = {
            file = {
              filename_only = true,
              git_status_hl = true,
            },
            severity = { pos = "right" },
          },
          win = {
            list = {
              keys = {
                ["<CR>"] = "confirm",
                ["l"] = "confirm",
                ["h"] = "explorer_close",
                ["<BS>"] = "explorer_up",
                ["a"] = "explorer_add",
                ["d"] = "explorer_del",
                ["r"] = "explorer_rename",
                ["c"] = "explorer_copy",
                ["m"] = "explorer_move",
                ["P"] = "toggle_preview",
                ["H"] = "toggle_hidden",
                ["I"] = "toggle_ignored",
                ["u"] = "explorer_update",
                ["<space>"] = "none",
                ["Y"] = "explorer_yank",
                ["O"] = "explorer_open",
                ["p"] = "explorer_paste",
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.explorer({ cwd = require("lazyvim.util").root() })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        Snacks.explorer({ git_status = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffer Explorer",
    },
  },
}
