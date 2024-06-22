return {
    "kevinhwang91/nvim-hlslens",
    config = function()
        local nmap = require("config/utils").nmap
        require('hlslens').setup({
            nearest_only = true,
        })
        nmap("n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
        nmap("N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
        nmap("*", [[<Cmd>execute('normal! ' . v:count1 . '*')<CR><Cmd>lua require('hlslens').start()<CR>]])
        nmap('#', [[#<Cmd>lua require('hlslens').start()<CR>]])
        nmap('g*', [[g*<Cmd>lua require('hlslens').start()<CR>]])
        nmap('g#', [[g#<Cmd>lua require('hlslens').start()<CR>]])
    end
}

