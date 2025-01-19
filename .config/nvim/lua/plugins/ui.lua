return {
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
		opts = {
			theme = "hyper",
			config = {
				week_header = {
					enable = true, --boolean use a week header
				},
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
				},
			},
		},
	},
	{
		"romgrk/barbar.nvim",
		vent = "BufReadPost",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "BufReadPost",
		opts = {},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			stages = "static",
			presets = {
				lsp_doc_border = true,
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = true,
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
				},
				signature = {
					enabled = true,
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
				},
			},
		},
		keys = {
			{
				"<leader>nh",
				"<cmd>NoiceHistory<cr>",
				desc = "NoiceHistory",
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		event = "BufReadPost",
		opts = {},
	},
	{
		"echasnovski/mini.cursorword",
		event = "BufReadPost",
		opts = {},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"dashboard",
				},
			},
		},
	},
	{
		"echasnovski/mini.diff",
		event = "BufReadPost",
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
		"MeanderingProgrammer/render-markdown.nvim",
		event = "BufReadPost",
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		event = "BufReadPost",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = ".",
				},
			},
			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url })
			end,
		},
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "ColorizerToggle" },
		opts = {
			"*",
		},
		{
			"vinnymeller/swagger-preview.nvim",
			event = "BufReadPost",
			cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
			build = "npm i",
			config = true,
			opts = {
				port = 8000,
				host = "localhost",
			},
			keys = {
				{
					"<leader>sp",
					"<cmd>SwaggerPreview<cr>",
					desc = "SwaggerPreview",
				},
			},
		},
	},
}
