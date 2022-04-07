local set = vim.opt

vim.cmd "filetype plugin indent on"
vim.cmd "filetype plugin on"

set.autoindent = true
set.cursorline = true
set.expandtab = true
set.tabstop = 4
set.shiftwidth = 4
set.shiftround = true
set.softtabstop = 4
set.ignorecase = true
set.smartcase = true
set.scrolloff = 3
set.backspace = {"indent", "eol", "start"}
set.formatoptions = set.formatoptions + 'ro'
set.modelines = 0
set.hlsearch = true
set.splitright = true
set.splitbelow = true
set.number = true
set.relativenumber = true
set.autoread = true
set.showtabline = 1
set.signcolumn = "number"
set.completeopt = "menu,menuone,noselect"
