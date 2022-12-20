require('gitsigns').setup {
    signs = {
        add = {hl = 'GitSignsAdd' , text = '+', numhl='DiffAdd' , linehl='DiffAdd'},
        change = {hl = 'GitSignsChange' , text = '~', numhl='DiffChange' , linehl='DiffChange'},
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr=true})
        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr=true})
        map('n', '<leader>hr', gs.reset_hunk)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>gb', gs.blame_line)
    end
}
