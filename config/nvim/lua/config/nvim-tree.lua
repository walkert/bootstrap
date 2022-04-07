vim.api.nvim_set_keymap('n', '<C-t>', ":NvimTreeToggle<CR>", { noremap = true, silent = true })

local tree_cb = require'nvim-tree.config'.nvim_tree_callback
require'nvim-tree'.setup {
    actions = {
        open_file = {
            quit_on_open = true
        }
    },
    view = {
        mappings = {
            list = {
                { key = {"t"}, cb = tree_cb("tabnew") },
                { key = {"<C-t>"}, cb = tree_cb("close") },
            }
        }
    }
}
