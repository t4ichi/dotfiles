return {
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		opts = {
			mirage = true,
			terminal = true,
			overrides = {},
		},
		config = function()
			vim.cmd([[colorscheme ayu-mirage]])
		end,
	},
}
