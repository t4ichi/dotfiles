return {
	{
		"simonmclean/triptych.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"antosha417/nvim-lsp-file-operations",
		},
		opts = {},
		keys = {
			{ "<leader>e", ":Triptych<CR>" },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules/",
						"%.git/",
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup()
		end,
	},
	{
		"echasnovski/mini.cursorword",
		config = function(_, opts)
			require("mini.cursorword").setup(opts)
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mini.indentscope").setup()
		end,
	},
	{
		"echasnovski/mini.diff",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>go",
				function()
					require("mini.diff").toggle_overlay(0)
				end,
				desc = "Toggle mini.diff overlay",
			},
		},
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = {},
		keys = {
			{ "<leader>ho", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Open DiffView against HEAD~1" },
			{ "<leader>hh", "<cmd>DiffviewFileHistory<CR>", desc = "Open DiffView File History" },
			{ "<leader>hc", "<cmd>DiffviewClose<CR>", desc = "Close DiffView" },
			{
				"<leader>hm",
				"<cmd>DiffviewOpen origin/main...HEAD<CR>",
				desc = "Open DiffView against origin/main...HEAD",
			},
			{
				"<leader>hd",
				"<cmd>DiffviewOpen origin/develop...HEAD<CR>",
				desc = "Open DiffView against origin/develop...HEAD",
			},
			{
				"<leader>hf",
				"<cmd>DiffviewOpen origin/frontend...HEAD<CR>",
				desc = "Open DiffView against origin/frontend...HEAD",
			},
		},
	},
}
