return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
            "astro",
            "bash",
            "c",
            "comment",
            "cpp",
            "css",
            "dart",
            "dockerfile",
            "go",
            "gomod",
            "graphql",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "make",
            "markdown",
            "php",
            "prisma",
            "python",
            "regex",
            "rust",
            "scss",
            "sparql",
            "sql",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "yaml",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        })
    end
}