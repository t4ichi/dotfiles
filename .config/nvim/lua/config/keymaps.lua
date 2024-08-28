vim.g.mapleader = " "

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })

-- cursor
vim.api.nvim_set_keymap("", "k", "gk", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "K", "10k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "J", "10j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "H", "0", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "L", "$", { noremap = true, silent = true })

-- edit
vim.api.nvim_set_keymap("", "x", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- buffer
vim.api.nvim_set_keymap("", "<Leader>w", ":w<CR>", { noremap = true, silent = true })
