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
		event = "VeryLazy",
		opts = {
			defaults = {
				file_ignore_patterns = {
					"node_modules/",
					"%.git/",
				},
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Telescope find files",
				mode = "n",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Telescope live grep",
				mode = "n",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Telescope buffers",
				mode = "n",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Telescope help tags",
				mode = "n",
			},
		},
	},
	{
		"kdheepak/lazygit.nvim",
		event = "VeryLazy",
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
		event = "VeryLazy",
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
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
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
