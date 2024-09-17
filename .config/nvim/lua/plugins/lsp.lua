return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end
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
            -- Add this configuration to enable formatting
            on_attach = function(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                  end,
                })
              end
            end,
            -- You can add more server-specific settings here
          })
        end,
      })
      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
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
      vim.api.nvim_create_autocmd("LspAttach", {

        callback = function()
          local opts = { noremap = true, silent = true }
          vim.keymap.set('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<CR>')
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<CR>')
          vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR>')
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
          vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        end
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        }),
      })
    end
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
  {
    "garymjr/nvim-snippets",
    opts = {
      friendly_snippets = true,
    },
    dependencies = { "rafamadriz/friendly-snippets" },
  },
}
