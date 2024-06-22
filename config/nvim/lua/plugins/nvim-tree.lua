return {
    "kyazdani42/nvim-tree.lua",
    keys = {
        { "<C-t>", ":NvimTreeToggle<CR>", desc = "NvimTree" },
    },
    config = function()
        require'nvim-tree'.setup {
            actions = {
                open_file = {
                    quit_on_open = true
                }
            },
            on_attach = function(bufnr)
                local api = require('nvim-tree.api')

                local function opts(desc)
                return {
                    desc = 'nvim-tree: ' .. desc,
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true,
                }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
                vim.keymap.set('n', '<C-t>', api.tree.close, opts('Close'))
            end
        }
    end
}
