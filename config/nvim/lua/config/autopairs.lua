require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
  ignored_next_char = "[%w%.%]%[]"
})
-- Configure autopairs for cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
-- Remove rules I don't care about
require('nvim-autopairs').remove_rule('{')
require('nvim-autopairs').remove_rule('[')
require('nvim-autopairs').remove_rule('"')
require('nvim-autopairs').remove_rule('\'')
