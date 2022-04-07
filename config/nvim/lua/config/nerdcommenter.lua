vim.g.NERDCreateDefaultMappings = 0
vim.api.nvim_set_keymap('n', '<leader>c', "<Plug>NERDCommenterToggle", { silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', "<Plug>NERDCommenterToggle", { silent = true })
