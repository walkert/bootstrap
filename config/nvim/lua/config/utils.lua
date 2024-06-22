-- Create a function to set keymaps with sane defaults
local map = function(mode, lhs, rhs, desc, opts)
  local local_opts = {noremap = true, silent = true}
  desc = desc or ""
  opts = opts or {}
  vim.tbl_deep_extend('force', local_opts, opts)
  vim.keymap.set(mode, lhs, rhs, local_opts)
end

local nmap = function(lhs, rhs, desc, opts)
    map("n", lhs, rhs, desc, opts)
end

local imap = function(lhs, rhs, desc, opts)
    map("i", lhs, rhs, desc, opts)
end

local object = {}
object.map = map
object.nmap = nmap
object.imap = imap
object.toggle_qf = function()
  local qf_exists = false
  local loc_exists = false
  local winnr = vim.api.nvim_get_current_win()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
    if win["loclist"] == 1 then
      loc_exists = true
    end
  end
  if qf_exists and loc_exists then
    vim.cmd "cclose"
    vim.cmd "lclose"
    return
  end
  if qf_exists then
    vim.cmd "cclose"
    return
  end
  if loc_exists then
    vim.cmd "lclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
    return
  end
  if not vim.tbl_isempty(vim.fn.getloclist(winnr)) then
    vim.cmd "lopen"
  end
end
return object
