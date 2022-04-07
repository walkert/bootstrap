local on_attach = require('config/utils').on_attach
local opts = {
    tools = {
        inlay_hints = {
            only_current_line = true,
            only_current_line_autocmd = "CursorMoved,CursorMovedI",
        }
    },
    server = {
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        }
    }
}

require('rust-tools').setup(opts)
