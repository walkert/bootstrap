require("nvim-surround").setup()
-- Must set using nvim_set_keymap for some reason. vim.keymap.set doesn't work.
vim.api.nvim_set_keymap('n', '<leader>s', 'ysiw', { noremap = false, silent = true, desc = "Set Surround around word" })
vim.api.nvim_set_keymap('n', '<leader>S', 'ysiW', { noremap = false, silent = true, desc = "Set Surround around WORD" })
