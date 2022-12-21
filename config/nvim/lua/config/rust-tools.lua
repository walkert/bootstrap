local rt = require('rust-tools')
local on_attach = require('config/utils').on_attach
local nmap = require("config/utils").nmap
local opts = {
    server = {
        on_attach = function(_, bufnr)
            -- Add some Rust-specific maps
            -- Hover actions
            nmap("<C-space>", rt.hover_actions.hover_actions, "Rust Hover Actions", { buffer = bufnr })
            -- Open Cargo.toml
            nmap("<space>t", rt.open_cargo_toml.open_cargo_toml, "Rust: Open Cargo [T]oml", { buffer = bufnr })
            return on_attach(_, bufnr)
        end,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        }
    }
}

rt.setup(opts)
