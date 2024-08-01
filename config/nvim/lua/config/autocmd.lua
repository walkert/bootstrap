-- Red on lines with greater than 79 chars in Python
local nmap = require('config/utils').nmap
vim.api.nvim_create_autocmd(
    'BufWinEnter',
    {
        callback = function()
            vim.w.m2 = vim.fn.matchadd('ErrorMsg', '\\%>79v.*', -1)
        end,
        pattern = '*.py'
    }
)
-- Briefly highlight yanked lines
vim.api.nvim_create_autocmd(
    'TextYankPost',
    {
        callback = function()
            vim.highlight.on_yank()
        end,
        pattern = '*',
    }
)
-- Refresh files when entering
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'VimResume' }, { command = 'checktime' })
-- Auto-close the quickfix window once an entry has been selected
vim.api.nvim_create_autocmd(
    'FileType',
    {
        pattern = { 'qf' },
        callback = function()
            nmap("<CR>", "<CR>:cclose<CR>:lclose<CR>", "Select an entry and then close the qf window")
            nmap("q", ":cclose<CR>:lclose<CR>", "Close the qf window")
        end,
    }
)
-- Remove trailling whitespace before save
vim.api.nvim_create_autocmd(
    'BufWritePre',
    {
        callback = function()
            vim.cmd [[%s/\s\+$//e]]
        end,
        pattern = "*",
    }
)
