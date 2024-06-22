local nmap = require('config/utils').nmap
local imap = require('config/utils').imap

-- Lazy
nmap("<leader>L", "<cmd>Lazy<CR>", "Lazy")

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

-- Hit zz/qww to write/quit
imap("zz", "<ESC>:wq!<CR>")
imap("qww", "<ESC>:wq!<CR>")
nmap("qww", "<ESC>:wq!<CR>")

-- Hit qd to delete the current buffer
nmap("qd", "<ESC>:bd<CR>")

-- Avoid ex mode
nmap("Q", "<NOP>")

-- Goto file in a new tab
nmap("gf", "<C-W>gf")

-- Toggle list/nolist
nmap(
    "<leader>l",
    function()
        vim.wo.list = (vim.wo.list == false and true or false)
    end,
    "Toggle list/nolist"
)

-- Select pasted lines
nmap("<leader>v", "V`]")

-- Toggle signcolumn and indent
nmap(
  "<leader>nn",
  function()
      vim.wo.number = (vim.wo.number == false and true or false)
      vim.wo.relativenumber = (vim.wo.relativenumber == false and true or false)
      vim.wo.signcolumn = (vim.wo.signcolumn == "no" and "number" or "no")
      vim.wo.statuscolumn = (vim.wo.statuscolumn == "" and "%!v:lua.StatusCol()" or "")
      require("ibl").setup_buffer(0, {
        enabled = not require("ibl.config").get_config(0).enabled,
      })
  end,
  "Toggle signcolumn and indent-blankline"
)

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

-- Toggle built-in commenting
-- For some reason - this must be set via nvim_set_keymap direct
vim.api.nvim_set_keymap('n', '<leader>c', "gcc", { silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', "gc", { silent = true })

-- Toggle relative line numbers
nmap(
  "<leader>ln",
  function()
      vim.wo.relativenumber = (vim.wo.relativenumber == false and true or false)
  end,
  "Toggle relative line numbers"
)
