local lsp_servers = {
  "lua_ls",
  "ts_ls",
  "html",
  "cssls",
  "biome",
  "eslint",
  "jsonls",
  "typos_lsp",
  "tailwindcss",
}

local js_formatters = {
  "biome-check",
  "prettier",
}

return {
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    event = "BufReadPost",
    dependencies = {
      {
        "mason-org/mason-lspconfig.nvim",
        version = "^1.0.0",
      },
      "neovim/nvim-lspconfig",
      "jay-babu/mason-null-ls.nvim",
      "nvimtools/none-ls.nvim",
      -- "ray-x/lsp_signature.nvim",
    },

    config = function()
      require("mason").setup()
      local mason_lsp = require("mason-lspconfig")
      mason_lsp.setup({
        ensure_installed = lsp_servers,
      })

      local lspconfig = require("lspconfig")
      mason_lsp.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,
      })
      -- typo
      lspconfig.typos_lsp.setup({
        init_options = {
          diagnosticSeverity = "Warning",
        },
      })

      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.hover()<CR>")
          vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")
          vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>")
          vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>")
          vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>")
          vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.rename()<CR>")
          vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
          vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
          vim.keymap.set("n", "gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
          vim.keymap.set("n", "gN", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
          -- lsp signature
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
            return
          end
          -- require("lsp_signature").on_attach({
          --   bind = true,
          --   handler_opts = {
          --     border = "rounded",
          --   },
          -- }, bufnr)
        end,
      })
    end,
  },
  -- cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      luasnip.filetype_extend("typescript", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html" })
      luasnip.filetype_extend("javascriptreact", { "html" })

      vim.opt.completeopt = { "menu", "menuone" }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "luasnip" },
          { name = "nvim_lsp" },
          -- { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
        },
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = {
              menu = 50,
              abbr = 50,
            },
            ellipsis_char = "...",
          }),
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        ["javascript"] = js_formatters,
        ["javascriptreact"] = js_formatters,
        ["typescript"] = js_formatters,
        ["typescriptreact"] = js_formatters,
        ["json"] = js_formatters,
        ["css"] = js_formatters,
      },
    },
  },
  -- rename path
  {
    "antosha417/nvim-lsp-file-operations",
    event = "BufReadPost",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "simonmclean/triptych.nvim",
    },
    opts = {},
  },
}
