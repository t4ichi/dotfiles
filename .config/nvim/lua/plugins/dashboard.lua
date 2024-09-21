return {
  -- 'nvimdev/dashboard-nvim',
  -- event = 'VimEnter',
  -- config = function()
  --   --  local logo = [[
  --   -- ██╗████████╗ ██████╗ ██╗   ██╗    ████████╗ █████╗ ██╗ ██████╗██╗  ██╗██╗
  --   -- ██║╚══██╔══╝██╔═══██╗██║   ██║    ╚══██╔══╝██╔══██╗██║██╔════╝██║  ██║██║
  --   -- ██║   ██║   ██║   ██║██║   ██║       ██║   ███████║██║██║     ███████║██║
  --   -- ██║   ██║   ██║   ██║██║   ██║       ██║   ██╔══██║██║██║     ██╔══██║██║
  --   -- ██║   ██║   ╚██████╔╝╚██████╔╝       ██║   ██║  ██║██║╚██████╗██║  ██║██║
  --   -- ╚═╝   ╚═╝    ╚═════╝  ╚═════╝        ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝
  --   --  ]]
  --
  --   require('dashboard').setup {
  --     theme = 'hyper',
  --     config = {
  --       -- header = vim.split(logo, "\n"),  -- Display the logo
  --       week_header = {
  --         enable=true  --boolean use a week header
  --       },
  --       shortcut = {
  --         { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
  --         {
  --           icon = ' ',
  --           icon_hl = '@variable',
  --           desc = 'Files',
  --           group = 'Label',
  --           action = 'Telescope find_files',
  --           key = 'f',
  --         },
  --       },
  --     }
  --   }
  -- end,

  -- dependencies = { {'nvim-tree/nvim-web-devicons'} }

{
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("dashboard")
    local logo = [[

██╗████████╗ ██████╗     ████████╗ █████╗ ██╗ ██████╗██╗  ██╗██╗
██║╚══██╔══╝██╔═══██╗    ╚══██╔══╝██╔══██╗██║██╔════╝██║  ██║██║
██║   ██║   ██║   ██║       ██║   ███████║██║██║     ███████║██║
██║   ██║   ██║   ██║       ██║   ██╔══██║██║██║     ██╔══██║██║
██║   ██║   ╚██████╔╝       ██║   ██║  ██║██║╚██████╗██║  ██║██║
╚═╝   ╚═╝    ╚═════╝        ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝
                                                                
    ]]
    logo = string.rep("\n", 8) .. logo .. "\n\n"
    dashboard.setup({
      theme = 'doom',
      config = {
        header = vim.split(logo, "\n"),
        center = {
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Find File           ',
            desc_hl = 'String',
            key = 'f',
            key_hl = 'Number',
            key_format = '  %s',
            action = 'Telescope find_files'
          },
          {
            icon = ' ',
            desc = 'New File            ',
            key = 'n',
            action = 'enew'
          },
          {
            icon = ' ',
            desc = 'Recent Files        ',
            key = 'r',
            action = 'Telescope oldfiles'
          },
          {
            icon = ' ',
            desc = 'Find Text           ',
            key = 'g',
            action = 'Telescope live_grep'
          },
          {
            icon = ' ',
            desc = 'Config              ',
            key = 'c',
            action = 'edit ~/.config/nvim/init.lua'
          },
          {
            icon = ' ',
            desc = 'Quit                ',
            key = 'q',
            action = 'qa'
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end
      }
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' }
}
}
