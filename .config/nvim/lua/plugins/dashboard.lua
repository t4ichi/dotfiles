return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local logo = [[
   ██╗████████╗ ██████╗ ██╗   ██╗    ████████╗ █████╗ ██╗ ██████╗██╗  ██╗██╗
   ██║╚══██╔══╝██╔═══██╗██║   ██║    ╚══██╔══╝██╔══██╗██║██╔════╝██║  ██║██║
   ██║   ██║   ██║   ██║██║   ██║       ██║   ███████║██║██║     ███████║██║
   ██║   ██║   ██║   ██║██║   ██║       ██║   ██╔══██║██║██║     ██╔══██║██║
   ██║   ██║   ╚██████╔╝╚██████╔╝       ██║   ██║  ██║██║╚██████╗██║  ██║██║
   ╚═╝   ╚═╝    ╚═════╝  ╚═════╝        ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝
    ]]

    require('dashboard').setup {
      config = {
        header = vim.split(logo, "\n"),  -- Display the logo
        -- You can add other configurations like center, footer, etc. here
      }
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'} }
}
