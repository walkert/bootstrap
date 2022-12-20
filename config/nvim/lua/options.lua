local set = vim.opt

set.completeopt = "menu,menuone,noselect"
set.cursorline = true
set.expandtab = true
set.formatoptions = set.formatoptions + 'ro'
set.ignorecase = true
set.listchars = "eol:$,tab:>-"
set.modelines = 0
set.mouse = ""
set.number = true
set.relativenumber = true
set.scrolloff = 3
set.shiftround = true
set.shiftwidth = 4
set.showtabline = 1
set.signcolumn = "number"
set.smartcase = true
set.softtabstop = 4
set.splitbelow = true
set.splitright = true
set.tabstop = 4
set.undodir = "/tmp/.nvim/undo"
set.undofile = true

-- Colours

set.pumblend = 7
set.termguicolors = true
