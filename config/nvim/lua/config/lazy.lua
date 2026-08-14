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
  -- `stable` is a moving tag, so a fresh clone lands on whatever it points at
  -- today, not on the commit in lazy-lock.json. lazy.nvim excludes itself from
  -- `:Lazy install` (it is already "installed" by the time the spec is read),
  -- so nothing ever corrects it -- but the lockfile is still rewritten from
  -- on-disk state afterwards, which records the drift. Pin it here instead.
  local lockfile = io.open(vim.fn.stdpath("config") .. "/lazy-lock.json", "r")
  if lockfile then
    local ok, lock = pcall(vim.json.decode, lockfile:read("*a"))
    lockfile:close()
    local pin = ok and lock["lazy.nvim"] and lock["lazy.nvim"].commit
    if pin then
      vim.fn.system({ "git", "-C", lazypath, "checkout", "--quiet", pin })
    end
  end
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
