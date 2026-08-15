return {
    "kevinhwang91/nvim-hlslens",
    -- Only matters once a search is started, so it can wait for the first
    -- paint. Note it does a `pcall(require, 'ufo')` on load looking for the
    -- fold integration; with no nvim-ufo installed that is a failed search of
    -- every rtp entry (~7ms measured) -- deferring gets it off the hot path.
    event = "VeryLazy",
    config = function()
        local nmap = require("config/utils").nmap
        require('hlslens').setup({
            nearest_only = true,
        })
        -- `n`/`N` are also mapped in config/mappings.lua as `nzzzv`/`Nzzzv`
        -- (centre the cursor after a jump). Whichever of the two runs last
        -- used to win by accident: when this plugin was eager it lost to
        -- mappings.lua, and deferring it to VeryLazy silently flipped that,
        -- taking the `zzzv` centring with it. Fold the centring in here so the
        -- result no longer depends on load order and both behaviours survive.
        nmap("n", [[<Cmd>execute('normal! ' . v:count1 . 'nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]])
        nmap("N", [[<Cmd>execute('normal! ' . v:count1 . 'Nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]])
        nmap("*", [[<Cmd>execute('normal! ' . v:count1 . '*')<CR><Cmd>lua require('hlslens').start()<CR>]])
        nmap('#', [[#<Cmd>lua require('hlslens').start()<CR>]])
        nmap('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]])
        nmap('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]])
    end
}

