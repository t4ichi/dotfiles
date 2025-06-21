return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }
      keys[#keys + 1] = { "gk", vim.lsp.buf.hover, desc = "Hover" }
      keys[#keys + 1] = { "ga", vim.lsp.buf.code_action, desc = "Code Action" }
    end,
  },
}
