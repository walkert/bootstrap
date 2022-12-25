-- Speed up load time
if pcall(require, 'imatient') then
    require 'impatient'
end

-- Skip some remote provider loading
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'shada_plugin',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
  'netrwPlugin',
}

for i, v in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. v] = 1
end
-- Plugin management via Packer
require("plugins")
-- Vim mappings, see lua/config/which.lua for more mappings
require("mappings")
-- All non plugin related (vim) options
require("options")
-- Vim autocommands/autogroups
require("autocmd")
