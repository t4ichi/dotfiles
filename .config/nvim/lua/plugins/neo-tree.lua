return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          dir = require("lazyvim.util").root(),
          position = "float",
        })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          dir = vim.uv.cwd(),
          position = "float",
        })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({
          source = "git_status",
          toggle = true,
          position = "float",
        })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({
          source = "buffers",
          toggle = true,
          position = "float",
        })
      end,
      desc = "Buffer Explorer",
    },
  },
  opts = {
    -- Core configuration
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    popup_border_style = "rounded",

    -- Filesystem configuration
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files by default
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
      bind_to_cwd = false,
      follow_current_file = { enabled = true, leave_dirs_open = false },
      use_libuv_file_watcher = true,
    },

    -- Window configuration
    window = {
      position = "float",
      popup = {
        size = { height = "80%", width = "50%" },
        position = { col = "50%", row = "50%" },
      },
      mappings = {
        -- Navigation
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",

        -- Utility functions
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            vim.fn.setreg("+", node:get_id(), "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },

        -- Preview
        ["P"] = { "toggle_preview", config = { use_float = true } },
      },
    },

    -- Preview configuration
    preview = {
      enabled = true,
      use_float = true,
    },
  },
}
