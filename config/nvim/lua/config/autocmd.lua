-- Red on lines with greater than 79 chars in Python
local nmap = require('config/utils').nmap
vim.api.nvim_create_autocmd(
    'BufWinEnter',
    {
        callback = function()
            -- Matches are window-local and BufWinEnter fires again whenever
            -- the buffer re-enters a window, so skip if this window already
            -- has one -- otherwise they stack up on every split/tab visit.
            if vim.w.m2 then
                return
            end
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
            -- vim.highlight was renamed vim.hl in 0.11; the old name is a
            -- deprecated alias that will eventually be removed.
            (vim.hl or vim.highlight).on_yank()
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
            -- All three must be buffer-local: without `buffer`, opening a
            -- quickfix window once rebinds <CR> and q globally for the rest
            -- of the session (a global q breaks macro recording).
            nmap("o", "<CR>", "Select an entry from the list", { buffer = true })
            nmap("<CR>", "<CR>:cclose<CR>:lclose<CR>", "Select an entry and then close the qf window", { buffer = true })
            nmap("q", ":cclose<CR>:lclose<CR>", "Close the qf window", { buffer = true })
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
            -- A bare :%s moves the cursor and clobbers the last search
            -- pattern, so save the view and use keeppatterns.
            local view = vim.fn.winsaveview()
            vim.cmd [[keeppatterns %s/\s\+$//e]]
            vim.fn.winrestview(view)
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
