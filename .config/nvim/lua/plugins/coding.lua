return {
	-- {
	-- 	"echasnovski/mini.pairs",
	-- 	event = "InsertEnter",
	-- 	opts = {},
	-- },
	--
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		lazy = true,
		keys = {
			{ "gc", mode = { "n", "x" } },
			{ "gb", mode = { "n", "x" } },
			{ "gcc", mode = "n" },
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufReadPost",
		lazy = true,
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
}
