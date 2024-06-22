local vmap = require("config.utils").map
local nmap = require("config.utils").nmap
local on_attach = function(client, bufnr)
-- A table of languages we want to enable auto-formatting for
local langs_to_format = {
    go = true,
    rust = true,
}
    -- Enable inlay hints by default
    vim.lsp.inlay_hint.enable()

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vimlsp.omnifunc", {buf=bufnr})

    -- Mappings.
    local bufopts = { buffer=bufnr }
    nmap('[d', "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostic message", bufopts)
    nmap(']d', "<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic message", bufopts)
    nmap('<space>d', vim.diagnostic.setloclist, "Add diagnostic messages to the location list", bufopts)
    nmap('gD', vim.lsp.buf.declaration, "[G]oto [D]eclaration", bufopts)
    nmap('gd', "<cmd>Lspsaga peek_definition<CR>", "[G]oto [d]efinition", bufopts)
    nmap('gt', vim.lsp.buf.type_definition, "[G]oto [T]ype Definition", bufopts)
    nmap('K', "<cmd>Lspsaga hover_doc<CR>", "Show Hover", bufopts)
    -- nmap('<C-k>', vim.lsp.buf.signature_help, "Show Signature Help", bufopts)
    nmap('<space>wa', vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder", bufopts)
    nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder", bufopts)
    nmap('<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "[W]orkspace [L]ist Folders", bufopts)
    nmap('<space>rn', "<cmd>Lspsaga rename<CR>", "[R]ename", bufopts)
    nmap('<space>a', "<cmd>Lspsaga code_action<CR>", "Code [A]ctions", bufopts)
    nmap('gr', "<cmd>Lspsaga finder<CR>", "[G]oto [R]eferences", bufopts)
    nmap('<space>f', function() vim.lsp.buf.format { async = true } end, "[F]ormat", bufopts)
    nmap('<space>o', "<cmd>Lspsaga outline<CR>", "[O]utline", bufopts)
    nmap('<space>t', "<cmd>Lspsaga term_toggle<CR>", "[T]erminal", bufopts)
    nmap('<space>i', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, "Toggle inlay hints", bufopts)

    -- Autocmd to format on write. For now, exclude Pythonkk
    vim.api.nvim_create_autocmd(
        "BufWritePre",
        {
            pattern = "*",
            callback = function()
                if langs_to_format[vim.bo.filetype] ~= nil then
                    vim.lsp.buf.format()
                    return
                end
            end,
        }
    )
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Display function signatures
        { "ray-x/lsp_signature.nvim", opts = {} },
        -- Show LSP status on open
        { "j-hui/fidget.nvim", opts = {} },
        -- Enhanced LSP tools
        {
            "glepnir/lspsaga.nvim",
            branch = "main",
            opts = {
                symbol_in_winbar = {
                    enable = false,
                },
                code_action = {
                    keys = {
                        -- string | table type
                        quit = {"q", "<ESC>"},
                        exec = "<CR>",
                    },
                },
            },
            keys = {
                {"<leader>fl", ":Lspsaga finder<CR>"}
            }
        },
    },
    config = function()
        local nvim_lsp = require('lspconfig')

        -- Use a loop to conveniently call 'setup' on multiple servers and
        -- map buffer local keybindings when the language server attaches
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        local servers = {
            bashls = true,
            efm = {
                init_options = {documentFormatting = true, hover = true},
                settings = {
                    languages = {
                        python = {
                            {
                                lintCommand = "flake8 --max-line-length 79 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
                                lintStdin = true,
                                lintIgnoreExitCode = true,
                                lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
                                lintSource = "flake8",
                                formatCommand = "black -l 79 -",
                                formatStdin = true,
                            }
                        },
                    },
                },
                filetypes = { 'python' },
                root_dir = nvim_lsp.util.root_pattern{".git/", "."},
            },
            gopls = {
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            rangeVariableTypes = true,
                            parameterNames = true,
                        }
                    }
                }
            },
            pyright = true,
            lua_ls = {
                settings = {
                    Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {'vim'},
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                    },
                },
            },
            rust_analyzer = true,
        }

        -- Configure each of the servers listed above
        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end
            config = vim.tbl_deep_extend(
                "force",
                {},
                {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    flags = {
                        debounce_text_changes = 150,
                    }
                },
                config
            )
            nvim_lsp[name].setup(config)
        end
    end
}
