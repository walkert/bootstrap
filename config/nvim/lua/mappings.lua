-- Create a function to set keymaps with sane defaults
local map = function(mode, lhs, rhs)
  -- get the extra options
  local opts = {noremap = true, silent = true}
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local nmap = function(lhs, rhs)
    map("n", lhs, rhs)
end

local imap = function(lhs, rhs)
    map("i", lhs, rhs)
end

vim.g.mapleader = ","

-- Tabs
nmap(",t", "<Esc>:tabnew<CR>")
nmap(",T", "<Esc>:tabclose<CR>")
nmap("-", "gT")
nmap("=", "gt")

-- Windows
nmap("<C-w>", "<C-w>w")

-- Ins escape
imap("jj", "<ESC>")

-- Hit qq to write/suspend
imap("qq", "<ESC>:w! | stop<CR>")
nmap("qq", "<ESC>:w! | stop<CR>")

-- Hit qw to write
imap("qw", "<ESC>:w!<CR>")
nmap("qw", "<ESC>:w!<CR>")

-- Hit qww to write/quit
imap("qww", "<ESC>:wq!<CR>")
nmap("qww", "<ESC>:wq!<CR>")

-- Hit qd to delete the current buffer
nmap("qd", "<ESC>:bd<CR>")

-- Avoid ex mode
nmap("Q", "<NOP>")

-- Goto file in a new tab
nmap("gf", "<C-W>gf")

-- Toggle list/nolist
nmap("<leader>l", ":set list<CR>")
nmap("<leader>ll", ":set nolist<CR>")

-- Select pasted lines
nmap("<leader>v", "V`]")

-- Toggle signcolumn
nmap("<leader>nn", ":setlocal nonumber norelativenumber signcolumn=no<CR>")
nmap("<leader>tn", ":setlocal number relativenumber signcolumn=number<CR>")

-- Clear highlighted searches
nmap("<leader>n", ":nohlsearch<CR>")
-- Buffers
nmap("<C-n>", ":bnext<CR>")
nmap("<C-p>", ":bprev<CR>")
