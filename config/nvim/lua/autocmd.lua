-- Red on lines with greater than 79 chars in Python
local python_group = vim.api.nvim_create_augroup('Python', { clear = true })
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
