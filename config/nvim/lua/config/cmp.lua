  -- Setup nvim-cmp.
local utils = require('config/utils')
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        -- This function will move the cursor to the next line when on ")", accept the first/current completion
        -- if one is available or just send <CR>
        ['<CR>'] = function(fallback)
            local next_char = vim.api.nvim_eval("strcharpart(getline('.')[col('.') - 1:], 0, 1)")
            --if next_char == "\"" or next_char == ")" or next_char == "'" or next_char == "]" or next_char == "}" then
            if next_char == ")" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, true, true), 'n', true)
            elseif cmp.visible() then
                cmp.confirm({ select  = true })
            else
                fallback()
            end
        end,
        -- Enable tab/shift-tab to cycle through completions (and snippets)
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    },
    sources = cmp.config.sources({
        {
            name = 'nvim_lsp',
            keyword_length = 3,
        },
        {
            name = 'luasnip',
            keyword_length = 3,
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
        format = utils.cmp_formatter,
    },
})

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
    sources = {{name = 'buffer'}}
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()
