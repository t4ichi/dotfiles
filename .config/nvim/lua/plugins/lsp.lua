return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                  end,
                })
              end

              -- LSP keymaps
              local opts = { noremap = true, silent = true, buffer = bufnr }
              vim.keymap.set('n', 'gK', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'gf', vim.lsp.buf.format, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            end,
          })
        end,
      })

      local function copy_diagnostic_message()
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diagnostics > 0 then
          local message = diagnostics[1].message
          vim.fn.setreg("+", message) -- Copy to system clipboard
          vim.fn.setreg('"', message) -- Copy to unnamed register
          print("Diagnostic message copied to clipboard")
        else
          print("No diagnostic message at cursor position")
        end
      end

      -- Diagnostic keymaps using <Leader>
      vim.keymap.set('n', '<Leader>lf', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
      vim.keymap.set('n', '<Leader>lp', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
      vim.keymap.set('n', '<Leader>ln', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
      vim.keymap.set('n', '<Leader>ll', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
      vim.keymap.set('n', '<Leader>lc', copy_diagnostic_message, { desc = "Copy diagnostic message" })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

      local ls = require("luasnip")
      ls.filetype_extend("typescript", { "javascript" })
      ls.filetype_extend("typescriptreact", { "typescript", "javascript", "react" })

      -- スニペット展開のキーマップ
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup()
    end
  },
}
