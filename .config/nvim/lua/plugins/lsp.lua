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
        "pyright",                -- Python
        "rust_analyzer",          -- Rust
        "gopls",                  -- Go
        "clangd",                 -- C/C++
        "jdtls",                  -- Java
        "kotlin_language_server", -- Kotlin
        "solargraph",             -- Ruby
        "eslint-lsp",             -- JavaScript/TypeScript Linting
        "jsonls",                 -- JSON
        "yamlls",                 -- YAML
        "dockerls",               -- Dockerfile
        "html-lsp",               -- HTML
        "marksman",               -- Markdown
        "sqlls",                  -- SQL
        "rome",                   -- JavaScript/TypeScript/JSON formatter
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/nvim-cmp" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,
        ["vtsls"] = function()
          lspconfig["vtsls"].setup({})
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(_)
          vim.keymap.set('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<CR>')
          vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>')
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
          vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
          vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.rename()<CR>')
          vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
          vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
          vim.keymap.set('n', 'gn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
          vim.keymap.set('n', 'gN', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
        end
      })

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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
    end
  },
}
