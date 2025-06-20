-- Set leader key
vim.g.mapleader = " "

-- Insert mode escape
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Cursor movement
vim.keymap.set("", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("", "K", "10k", { noremap = true, silent = true })
vim.keymap.set("", "J", "10j", { noremap = true, silent = true })

-- Edit operations
vim.keymap.set("", "x", '"_x', { noremap = true, silent = true })
vim.keymap.set("n", "c", '"_c', { noremap = true, silent = true })
vim.keymap.set("n", "dd", '"_dd', { noremap = true, silent = true })

-- Buffer operations
vim.keymap.set("", "<Leader>w", ":w<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<Leader>[", "<cmd>bprevious<cr>", { noremap = true, silent = true, desc = "Prev buffer" })
-- vim.keymap.set("n", "<Leader>]", "<cmd>bnext<cr>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<Leader>d", "<cmd>bdelete<cr>", { noremap = true, silent = true, desc = "Delete buffer" })

-- Window operations
vim.keymap.set("n", "<C-w>|", "<cmd>vsplit<cr>", { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set("n", "<C-w>-", "<cmd>split<cr>", { noremap = true, silent = true, desc = "Split window horizontally" })
