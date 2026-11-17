return {
    "lewis6991/gitsigns.nvim",
    -- Deferred: gitsigns attaches per-buffer on its own and re-scans buffers
    -- that are already open, so loading after the first paint loses nothing.
    -- It also shells out to `git --version` on load (~29ms measured), which is
    -- pure latency in a non-repo directory like ~/bin.
    event = "VeryLazy",
    config = function()
        local nmap = require('config/utils').nmap
        require('gitsigns').setup {
            current_line_blame_opts = {
                delay = 500,
            },
            -- NOTE: the old per-sign `hl`/`numhl`/`linehl` keys were dropped by
            -- gitsigns; `signs.*` now only takes `text` and `show_count`, and
            -- the highlights are the top-level `numhl` / `linehl` booleans
            -- (which drive GitSignsAddNr / GitSignsAddLn etc.). The previous
            -- block was silently ignored, so nothing is enabled here -- set
            -- `numhl = true` and/or `linehl = true` to turn it on.
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
