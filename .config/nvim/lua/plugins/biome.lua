return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        command = "npx",
        args = { "biome", "check", "--write", "--stdin-file-path", "$FILENAME" },
        stdin = true,
        cwd = function(_, ctx)
          local root = vim.fs.find({ "biome.json", "biome.jsonc" }, {
            path = ctx.filename,
            upward = true,
          })[1]
          return root and vim.fn.fnamemodify(root, ":h") or vim.fn.getcwd()
        end,
        condition = function(_, ctx)
          return vim.fs.find({ "biome.json", "biome.jsonc" }, {
            path = ctx.filename,
            upward = true,
          })[1] ~= nil
        end,
      }
      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {
          cmd = { "npx", "biome", "lsp-proxy" },
        },
      },
    },
  },
}
