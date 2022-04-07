vim.api.nvim_set_keymap('n', ',,', "<cmd>lua require('fzf-lua').git_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gr', "<cmd>lua require('fzf-lua').grep_cword()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', "<cmd>lua require('fzf-lua').command_history()<CR>", { noremap = true, silent = true })

local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  -- <CR> opens files in a new tab vs the current buffer
  actions = {
      files = {
          ["default"] = actions.file_tabedit,
      }
  }
}
