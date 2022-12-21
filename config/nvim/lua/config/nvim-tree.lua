local nmap = require("config/utils").nmap
nmap('<C-t>', ":NvimTreeToggle<CR>", "Toggle NvimTree")

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
