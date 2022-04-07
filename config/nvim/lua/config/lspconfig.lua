local nvim_lsp = require('lspconfig')
local on_attach = require('config/utils').on_attach

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = { 'gopls', 'pyright', 'terraformls' } -- rust_analyzer is configured by rust-tools

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
