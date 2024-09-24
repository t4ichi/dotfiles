return {
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.biome)
      table.insert(opts.sources, nls.builtins.formatting.prettier)
      table.insert(opts.sources, nls.builtins.diagnostics.eslint)
    end,
    config = function(_, opts)
      local nls = require("null-ls")
      nls.setup(opts)
      -- null-lsを使用した自動フォーマット設定
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            vim.lsp.buf.format({
            filter = function(client)
              return client.name == "null-ls"
            end,
            timeout_ms = 5000
          })
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
        },
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, server_opts in pairs(opts.servers) do
        lspconfig[server].setup(server_opts)
      end

      -- ESLint自動修正の設定
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
        callback = function(args)
          if vim.fn.exists(":EslintFixAll") > 0 then
            vim.cmd("EslintFixAll")
          end
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      local js_formatters = { "biome", "prettier", "eslint" }
      opts.formatters_by_ft.javascript = js_formatters
      opts.formatters_by_ft.typescript = js_formatters
      opts.formatters_by_ft.javascriptreact = js_formatters
      opts.formatters_by_ft.typescriptreact = js_formatters
      opts.formatters_by_ft.json = { "biome", "prettier" }
      opts.formatters_by_ft.jsonc = { "biome", "prettier" }

      -- conform.nvimを使用した自動フォーマット設定
      opts.format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,
  },
}
