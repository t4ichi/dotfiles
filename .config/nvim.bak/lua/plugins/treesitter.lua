return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = "all",
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
}
