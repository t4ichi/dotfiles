return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup {
            vim.keymap.set('n', '<Leader>tt', ':ToggleTerm direction=float<cr>'),
            vim.keymap.set('t', '<Leader>td', '<C-\\><C-n>:ToggleTerm<cr>'),
        }
    end
}
