return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup ({
      start_in_insert = true
    })

    -- Key mappings should be defined outside the setup function
    vim.keymap.set('n', '<Leader>tt', ':ToggleTerm direction=float<cr>')
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>:ToggleTerm<cr>')
  end
}
