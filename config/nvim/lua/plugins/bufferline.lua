return {
    "akinsho/bufferline.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    version = "*",
    config = function()
        local nmap = require('config/utils').nmap
        require('bufferline').setup {
            options = {
                mode = "tabs",
                left_trunc_marker = "",
                right_trunc_marker = "",
                diagnostics = "nvim_lsp",
                diagnostics_update_in_insert = true,
                offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
                show_buffer_icons = true,
                show_buffer_close_icons = false,
                show_tab_indicators = true,
                separator_style = 'padded_slant',
                --separator_style = 'padded_slant',
                enforce_regular_tabs = true,
                always_show_bufferline = false,
            },
            highlights = {
                buffer_selected = {
                    bold = false,
                    italic = false,
                    fg = "#afd700",
                },
            }
        }

        nmap('<leader>1', '<cmd>lua require("bufferline").go_to_buffer(1, true)<cr>', "Jump to tab")
        nmap('<leader>2', '<cmd>lua require("bufferline").go_to_buffer(2, true)<cr>', "Jump to tab")
        nmap('<leader>3', '<cmd>lua require("bufferline").go_to_buffer(3, true)<cr>', "Jump to tab")
        nmap('<leader>4', '<cmd>lua require("bufferline").go_to_buffer(4, true)<cr>', "Jump to tab")
        nmap('<leader>5', '<cmd>lua require("bufferline").go_to_buffer(5, true)<cr>', "Jump to tab")
        nmap('<leader>6', '<cmd>lua require("bufferline").go_to_buffer(6, true)<cr>', "Jump to tab")
        nmap('<leader>7', '<cmd>lua require("bufferline").go_to_buffer(7, true)<cr>', "Jump to tab")
        nmap('<leader>8', '<cmd>lua require("bufferline").go_to_buffer(8, true)<cr>', "Jump to tab")
        nmap('<leader>9', '<cmd>lua require("bufferline").go_to_buffer(9, true)<cr>', "Jump to tab")
        nmap('<leader>0', '<cmd>lua require("bufferline").go_to_buffer(10, true)<cr>', "Jump to tab")
        nmap('<leader>$', '<cmd>lua require("bufferline").go_to_buffer(-1, true)<cr>', "Jump to tab")
        nmap('<leader>^', '<cmd>lua require("bufferline").go_to_buffer(1, true)<cr>', "Jump to tab")
    end
}
