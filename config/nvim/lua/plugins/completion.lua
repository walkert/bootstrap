local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
}

local cmp_formatter = function(entry, vim_item)
    -- Kind icons
    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
    -- Source
    vim_item.menu = ({
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    luasnip = "[LuaSnip]",
    nvim_lua = "[Lua]",
    latex_symbols = "[LaTeX]",
    })[entry.source.name]
    return vim_item
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        {"abecodes/tabout.nvim", opts = {}},
    },
    event = "InsertEnter",
    config = function()
        -- Setup nvim-cmp.
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

        cmp.setup({
            enabled = function()
            -- disable completion in comments
            local context = require 'cmp.config.context'
            -- keep command mode completion enabled when cursor is in a comment
            if vim.api.nvim_get_mode().mode == 'c' then
                return true
            else
                return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
            end
            end,
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                ['<C-e>'] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                }),
                -- This function will accept the first/current completion if one is available or just send <CR>
                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select  = true })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Enable tab/shift-tab to cycle through completions (and snippets)
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    -- I don't use has_words_before() as I'm using tabout
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                {
                    name = 'nvim_lsp',
                    keyword_length = 3,
                },
                {
                    name = 'luasnip',
                    -- Use a short snippet length unless we're using shell scripts
                    -- where 'fi' will cause annoying snippet prompts
                    keyword_length = (vim.bo.filetype == "sh") and 5 or 2,
                },
                {
                    name = 'buffer',
                    keyword_length = 5,
                    option = {
                        -- This function gets buffer input from all open buffers in tabs
                        get_bufnrs = function()
                            local bufs = {}
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                bufs[vim.api.nvim_win_get_buf(win)] = true
                            end
                            return vim.tbl_keys(bufs)
                        end
                    }
                },
                { name = 'path' },
                { name = 'nvim_lua' },
            }),
            -- Use the cmp_formatter to add icons/text for completions in the menu
            formatting = {
                format = cmp_formatter,
            },
            experimental = {
                ghost_text = {
                hl_group = "CmpGhostText",
                },
            },
        })

        -- Use buffer source for `/`
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{name = 'buffer'}}
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
        })

        -- Load snippets
        require("luasnip.loaders.from_vscode").lazy_load()
    end
}
