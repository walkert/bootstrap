local nvim_lsp = require('lspconfig')
local on_attach = require('config/utils').on_attach

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = { 'gopls', 'pyright', 'lua_ls', 'terraformls' } -- rust_analyzer is configured by rust-tools

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- EFM setup
--
local python_settings = {
    lintCommand = "flake8 --max-line-length 79 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
    lintSource = "flake8",
    formatCommand = "black -l 79 -",
    formatStdin = true,
}
require "lspconfig".efm.setup {
    init_options = {documentFormatting = true, hover = true},
    settings = {
        languages = {
            python = {
                python_settings
            },
        },
    },
    filetypes = { 'python' },
    root_dir = require("lspconfig").util.root_pattern{".git/", "."},
}
-- Lua setup
require "lspconfig".lua_ls.setup {
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
}
