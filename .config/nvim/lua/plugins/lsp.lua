local lsp_servers = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
	"biome",
	"eslint",
	"jsonls",
}

local js_formatters = {
	"biome-check",
	"prettier",
	"shfmt",
}

return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"jay-babu/mason-null-ls.nvim",
			"nvimtools/none-ls.nvim",
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

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(_)
					vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.hover()<CR>")
					vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
					vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
					vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.rename()<CR>")
					vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
					vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
					vim.keymap.set("n", "gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
					vim.keymap.set("n", "gN", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
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
		},
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			vim.opt.completeopt = { "menu", "menuone" }
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},
	-- formatter
	{
		"stevearc/conform.nvim",
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
			formatters = {
				biome = {
					command = "biome",
					args = {
						"check",
						"--write",
						"--stdin-file-path",
						"$FILENAME",
					},
				},
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"simonmclean/triptych.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
