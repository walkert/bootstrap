-- Red on lines with greater than 79 chars in Python
local python_group = vim.api.nvim_create_augroup('Python', { clear = true })
local nmap = require('config/utils').nmap
vim.api.nvim_create_autocmd(
    'BufWinEnter',
    {
        callback = function()
            vim.w.m2 = vim.fn.matchadd('ErrorMsg', '\\%>79v.*', -1)
        end,
        group = python_group,
        pattern = '*.py'
    }
)
-- Briefly highlight yanked lines
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd(
    'TextYankPost',
    {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = '*',
    }
)
-- Refresh files when entering
local refresh_group = vim.api.nvim_create_augroup('Refresh', { clear = true })
vim.api.nvim_create_autocmd({'BufWinEnter', 'VimResume'}, { group = refresh_group, command = 'checktime' })
-- Auto-close the quickfix window once an entry has been selected
local quickfix_group = vim.api.nvim_create_augroup('QuickFixer', { clear = true })
vim.api.nvim_create_autocmd(
    'FileType',
    {
        group = quickfix_group,
        pattern = {'qf'},
        callback = function()
            nmap("<CR>", "<CR>:cclose<CR>:lclose<CR>","Select an entry and then close the qf window")
            nmap("q", ":cclose<CR>:lclose<CR>","Close the qf window")
        end,
        -- command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>:lclose<CR>]],
    }
)
