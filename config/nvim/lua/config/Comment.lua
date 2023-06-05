require('Comment').setup()
-- Set these using nvim_set_keymap as they don't work with keymap.set
vim.api.nvim_set_keymap('n', '<leader>c', "gcc", { silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', "gc", { silent = true })
