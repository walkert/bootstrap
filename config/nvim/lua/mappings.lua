local nmap = require('config/utils').nmap
local imap = require('config/utils').imap
local toggle_qf = require('config/utils').toggle_qf

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
imap("jk", "<ESC>")

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

-- Keep search results in the middle of the buffer
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Paste copied text and then immediately highlight it
nmap("vp", "p`[V`]")

-- Toggle the quickfix window
nmap("<leader>q", "<cmd>lua require('config/utils').toggle_qf()<CR>")
