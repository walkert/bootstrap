return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
      styles = {
          comments = { italic = false },
          keywords = { italic = false },
      }
  },
  init = function()
      vim.cmd([[colorscheme tokyonight-storm]])
  end,
}
