return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local opts = { noremap = true, silent = true }

			vim.api.nvim_set_keymap("n", "<Leader>ff", ":Telescope find_files hidden=true<cr>", opts)
			vim.api.nvim_set_keymap("n", "<Leader>fb", ":Telescope buffers<cr>", opts)
		end,
	},
	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup()
		end,
	},
	{
		"echasnovski/mini.files",
		opts = {
			windows = {
				preview = true,
			},
			mappings = {
				go_in_plus = "l",
				go_in = "L",
				close = "q",
			},
			options = {
				follow_current_file = true,
			},
			content = {
				filter = function(file)
					-- Function to check if a value exists in a table
					local function table_contains(table, value)
						for _, v in ipairs(table) do
							if v == value then
								return true
							end
						end
						return false
					end

					-- Files to ignore
					local ignored_files = {
						".DS_Store",
					}

					-- Split the file path
					local t = vim.fn.split(file.path, "/")
					local file_name = t[#t]

					-- Return true if the file is not in the ignored list
					return not table_contains(ignored_files, file_name)
				end,
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)

			vim.keymap.set("n", "<leader>e", ':lua require("mini.files").open()<cr>', { noremap = true, silent = true })
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
				"<cmd>DiffviewOpen origin/develop/frontend...HEAD<CR>",
				desc = "Open DiffView against origin/develop/frontend...HEAD",
			},
		},
	},
}
