return {
	{
		"folke/which-key.nvim",
		event = "BufReadPost",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"tyru/open-browser.vim",
		event = "BufReadPost",
		keys = {
			{ "gx", "<Plug>(openbrowser-smart-search)", desc = "Open URL under cursor" },
			{ "gx", "<Plug>(openbrowser-smart-search)", desc = "Search selected text", mode = "v" },
		},
	},
}
