-- Red on lines with greater than 79 chars in Python
local nmap = require('config/utils').nmap
vim.api.nvim_create_autocmd(
    'BufWinEnter',
    {
        callback = function()
            vim.w.m2 = vim.fn.matchadd('ErrorMsg', '\\%>79v.*', -1)
        end,
        group = vim.api.nvim_create_augroup("ErrorMsg", { clear = true }),
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
        group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
        pattern = '*'
    }
)
-- Refresh files when entering
vim.api.nvim_create_autocmd(
    { 'BufWinEnter', 'VimResume' },
    {
        command = 'checktime',
        group = vim.api.nvim_create_augroup("Refresh", { clear = true })
    }
)
-- Auto-close the quickfix window once an entry has been selected
vim.api.nvim_create_autocmd(
    'FileType',
    {
        callback = function()
            nmap("<CR>", "<CR>:cclose<CR>:lclose<CR>", "Select an entry and then close the qf window")
            nmap("q", ":cclose<CR>:lclose<CR>", "Close the qf window")
        end,
        group = vim.api.nvim_create_augroup("QFClose", { clear = true }),
        pattern = { 'qf' }
    }
)
-- Remove trailing whitespace before save
vim.api.nvim_create_autocmd(
    'BufWritePre',
    {
        callback = function()
            vim.cmd [[%s/\s\+$//e]]
        end,
        group = vim.api.nvim_create_augroup("TrailingSpace", { clear = true }),
        pattern = "*"
    }
)
-- Set comment strings for terraform and hcl files
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SetTFCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl" },
})
