-- Speed up load time
if pcall(require, 'imatient') then
    require 'impatient'
end

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
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
