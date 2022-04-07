require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {"python", "go"},
  },
  ensure_installed = {
      "go",
      "python",
      "rust",
  },
  rainbow = {
    enable = true,
  },
}
require'treesitter-context'.setup{
    enable = true,
}
