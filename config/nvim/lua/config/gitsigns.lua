vim.api.nvim_set_keymap('n', '<leader>gb', ":GitMessenger<CR>", { noremap = true, silent = true })
require('gitsigns').setup {
    signs = {
        add = {hl = 'GitSignsAdd' , text = '+', numhl='DiffAdd' , linehl='DiffAdd'},
        change = {hl = 'GitSignsChange' , text = '~', numhl='DiffChange' , linehl='DiffChange'},
    }
}
