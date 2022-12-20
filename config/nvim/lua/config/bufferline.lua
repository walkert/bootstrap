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

vim.keymap.set('n', '<leader>1', '<cmd>lua require("bufferline").go_to_buffer(1, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>2', '<cmd>lua require("bufferline").go_to_buffer(2, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>3', '<cmd>lua require("bufferline").go_to_buffer(3, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>4', '<cmd>lua require("bufferline").go_to_buffer(4, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>5', '<cmd>lua require("bufferline").go_to_buffer(5, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>6', '<cmd>lua require("bufferline").go_to_buffer(6, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>7', '<cmd>lua require("bufferline").go_to_buffer(7, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>8', '<cmd>lua require("bufferline").go_to_buffer(8, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>9', '<cmd>lua require("bufferline").go_to_buffer(9, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>0', '<cmd>lua require("bufferline").go_to_buffer(10, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>$', '<cmd>lua require("bufferline").go_to_buffer(-1, true)<cr>', {silent = true})
vim.keymap.set('n', '<leader>^', '<cmd>lua require("bufferline").go_to_buffer(1, true)<cr>', {silent = true})

vim.cmd([[

function CloseBuffer() 
  if winheight(0) + &cmdheight + 2 != &lines
    execute 'clo'
    return
  endif

  if winwidth(0) != &columns
    execute 'clo'
    return
  endif

  execute 'bdelete'
endfunction

]])
