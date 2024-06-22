return {
    "lewis6991/gitsigns.nvim",
    config = function()
        local nmap = require('config/utils').nmap
        require('gitsigns').setup {
            current_line_blame_opts = {
                delay = 500,
            },
            signs = {
                add = {hl = 'GitSignsAdd' , numhl='DiffAdd' , linehl='DiffAdd'},
                change = {hl = 'GitSignsChange' , numhl='DiffChange' , linehl='DiffChange'},
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local opts = { buffer = bufnr }
                -- Navigation
                nmap(']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, "Jump to next Git change", {buffer=bufnr, expr=true})
                nmap('[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, "Jump to previous Git change", {buffer=bufnr, expr=true})
                nmap('<leader>rh', gs.reset_hunk, "[R]eset Git [H]unk", opts)
                nmap('<leader>tb', gs.toggle_current_line_blame, "[T]oggle [B]lame", opts)
                nmap('<leader>gb', gs.blame_line, "[G]it [B]lame", opts)
            end
        }
    end
}
