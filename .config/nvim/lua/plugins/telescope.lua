return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local opts = { noremap = true, silent = true }

        -- Find files including hidden ones
        vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files hidden=true<cr>', opts)

        -- List open buffers
        vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<cr>', opts)
    end
}

