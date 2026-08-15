-- Language providers are for *remote plugins* (the pynvim/rplugin mechanism),
-- not for editing those languages -- Python files still get treesitter, LSP
-- and completion with these off. Nothing installed here ships an rplugin/
-- dir, but probing for the python3 host costs ~40ms of startup because it
-- shells out to an interpreter. Turn them off before anything else runs.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Configure Lazy
require("config.lazy")
-- Generic mappings
require("config.mappings")
-- Generic options
require("config.options")
-- autocommands/autogroups
require("config.autocmd")
