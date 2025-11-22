return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "K", false },
            { "gk", vim.lsp.buf.hover, desc = "Hover" },
            { "ga", vim.lsp.buf.code_action, desc = "Code Action" },
            { "ge", vim.diagnostic.open_float, desc = "Show Diagnostic" },
          },
        },
      },
    },
  },
}
