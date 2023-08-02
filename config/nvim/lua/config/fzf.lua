local nmap = require('config/utils').nmap

nmap(',,', "<cmd>lua require('fzf-lua').git_files()<CR>", "Search Git Files")
nmap('<leader>gr', "<cmd>lua require('fzf-lua').grep_cword()<CR>", "[GR]ep for the cursor word")
nmap('<leader>lg', "<cmd>lua require('fzf-lua').live_grep()<CR>", "[L]ive [G]rep")
nmap('<leader>sb', "<cmd>lua require('fzf-lua').buffers()<CR>", "[S]earch  [B]uffers")
nmap('<leader>sc', "<cmd>lua require('fzf-lua').command_history()<CR>", "[S]earch  [C]ommands")
nmap('<leader>sf', "<cmd>lua require('fzf-lua').files()<CR>", "[S]earch  [F]iles")
nmap('<leader>sh', "<cmd>lua require('fzf-lua').help_tags()<CR>", "[S]earch  [H]elp")
nmap('<leader>sk', "<cmd>lua require('fzf-lua').keymaps()<CR>", "[S]earch [K]eymaps")
nmap('<leader>sm', "<cmd>lua require('fzf-lua').marks()<CR>", "[S]earch [M]arks")
nmap('<leader>sgc', "<cmd>lua require('fzf-lua').git_commits()<CR>", "[S]earch  [G]it [C]ommits")
nmap('<leader>sgb', "<cmd>lua require('fzf-lua').git_bcommits()<CR>", "[S]earch  [G]it [B]uffer Commits")

local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  -- <CR> opens files in a new tab vs the current buffer
  actions = {
      files = {
          ["default"] = actions.file_tabedit,
      }
  }
}
