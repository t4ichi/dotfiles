-- Basic Settings

-- Set file encoding to UTF-8
vim.opt.encoding = "utf-8"

-- Display line numbers
vim.opt.number = true

-- Highlight the current line
vim.opt.cursorline = true

-- Highlight the current column
vim.opt.cursorcolumn = true

-- Indentation and Tab Settings

-- Set tab width to 2 spaces
vim.opt.tabstop = 2

-- Set soft tab width to 2 spaces in insert mode
vim.opt.softtabstop = 2

-- Set shift width for auto-indentation to 2 spaces
vim.opt.shiftwidth = 2

-- Convert tabs to spaces
vim.opt.expandtab = true

-- Enable auto-indentation
vim.opt.autoindent = true

-- Enable smart indentation
vim.opt.smartindent = true

-- Display Settings

-- Show command in the status line while typing
vim.opt.showcmd = true

-- Highlight search results
vim.opt.hlsearch = true

-- Always display the status line
vim.opt.laststatus = 2

-- File Handling Settings

-- Automatically reload files changed outside of Neovim
vim.opt.autoread = true

-- Disable swap file creation
vim.opt.swapfile = false

-- Disable backup file creation
vim.opt.backup = false

-- Disable backup before overwriting files
vim.opt.writebackup = false

-- Disable undo file creation
vim.opt.undofile = false

-- Help and Clipboard Settings

-- Set help language to Japanese
vim.opt.helplang = "ja"

-- Set the match time for highlighted matches
vim.opt.matchtime = 1

-- Use system clipboard for copy and paste
vim.opt.clipboard = "unnamedplus"

vim.opt.conceallevel = 2
