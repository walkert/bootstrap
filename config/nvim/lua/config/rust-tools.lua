local on_attach = require('config/utils').on_attach
local opts = {
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
