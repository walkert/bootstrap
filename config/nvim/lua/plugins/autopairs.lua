return {
    "windwp/nvim-autopairs",
    dependencies = {
        "hrsh7th/nvim-cmp"
    },
    event = "InsertEnter",
    config = function()
        local cmp = require('cmp')
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        require('nvim-autopairs').setup({
            disable_filetype = { "TelescopePrompt" , "vim" },
            ignored_next_char = "[%w%.%]%[]"
        })
        -- Configure autopairs for cmp
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
    end
}
