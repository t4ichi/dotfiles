vim.g.mapleader = " "

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })

-- cursor
vim.api.nvim_set_keymap("", "k", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "K", "10k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "J", "10j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "H", "b", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "L", "w", { noremap = true, silent = true })

vim.api.nvim_set_keymap("", "<C-h>", "0", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<C-l>", "$", { noremap = true, silent = true })

-- edit
vim.api.nvim_set_keymap("", "x", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D>", "dd", { noremap = true, silent = true })

-- buffer
vim.api.nvim_set_keymap("", "<Leader>w", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>[", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>]", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>d", "<Cmd>BufferClose<CR>", { noremap = true, silent = true })

-- window
vim.api.nvim_set_keymap("n", "<C-w>|", ":vsplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>-", ":split<CR>", { noremap = true, silent = true })
