-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Set leader first
vim.g.mapleader = ","
-- Set up lazy, and load my plugins folder
require("lazy").setup({ import = "plugins" }, {
  checker = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "man",
        "shada_plugin",
        "tarPlugin",
        "tar",
        "tohtml",
        "tutor",
        "zipPlugin",
        "zip",
        "netrwPlugin",
      }
    }
  }
})
