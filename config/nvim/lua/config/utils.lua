local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

-- Create a function to set keymaps with sane defaults
local map = function(mode, lhs, rhs, desc, opts)
  local_opts = {noremap = true, silent = true}
  if desc then
      local_opts.desc = desc
  end
  if opts then
    for k, v in pairs(opts) do
        local_opts[k] = v
    end
  end
  vim.keymap.set(mode, lhs, rhs, local_opts)
end

local nmap = function(lhs, rhs, desc, opts)
    map("n", lhs, rhs, desc, opts)
end

local imap = function(lhs, rhs, desc, opts)
    map("i", lhs, rhs, desc, opts)
end

local object = {}
object.on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { buffer=bufnr }
  nmap('[d', "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Jump to previous diagnostic message", bufopts)
  nmap(']d', "<cmd>Lspsaga diagnostic_jump_next<CR>", "Jump to next diagnostic message", bufopts)
  nmap('<space>d', vim.diagnostic.setloclist, "Add diagnostic messages to the location list", bufopts)
  nmap('gD', vim.lsp.buf.declaration, "[G]oto [D]eclaration", bufopts)
  nmap('gd', "<cmd>Lspsaga peek_definition<CR>", "[G]oto [d]efinition", bufopts)
  nmap('gt', vim.lsp.buf.type_definition, "[G]oto [T]ype Definition", bufopts)
  nmap('K', "<cmd>Lspsaga hover_doc<CR>", "Show Hover", bufopts)
  nmap('<C-k>', vim.lsp.buf.signature_help, "Show Signature Help", bufopts)
  nmap('<space>wa', vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder", bufopts)
  nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder", bufopts)
  nmap('<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "[W]orkspace [L]ist Folders", bufopts)
  nmap('<space>rn', "<cmd>Lspsaga rename<CR>", "[R]ename", bufopts)
  nmap('<space>a', "<cmd>Lspsaga code_action<CR>", "Code [A]ctions", bufopts)
  nmap('gr', "<cmd>Lspsaga finder<CR>", "[G]oto [R]eferences", bufopts)
  nmap('<space>f', function() vim.lsp.buf.format { async = true } end, "[F]ormat", bufopts)
  nmap('<space>o', "<cmd>Lspsaga outline<CR>", "[O]utline", bufopts)
  nmap('<space>t', "<cmd>Lspsaga term_toggle<CR>", "[T]erminal", bufopts)

end
object.cmp_formatter = function(entry, vim_item)
    -- Kind icons
    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
    -- Source
    vim_item.menu = ({
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    luasnip = "[LuaSnip]",
    nvim_lua = "[Lua]",
    latex_symbols = "[LaTeX]",
    })[entry.source.name]
    return vim_item
end
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
