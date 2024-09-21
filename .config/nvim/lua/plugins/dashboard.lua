return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        -- header = vim.split(logo, "\n"),  -- Display the logo
        week_header = {
          enable = true --boolean use a week header
        },
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
        },
      }
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
