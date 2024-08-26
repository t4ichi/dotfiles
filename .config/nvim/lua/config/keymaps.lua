vim.g.mapleader = " "

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "yy", "_yy", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "J", "10j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "10k", { noremap = true, silent = true })
