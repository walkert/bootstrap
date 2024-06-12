local fn = vim.fn

local package_root = fn.stdpath("config") .. "/pack"
local compile_path = fn.stdpath("config") .. "/plugin/packer_compiled.lua"

-- Ensure PackerSync runs when this file is modified
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd(
    'BufWritePost',
    {
        command = 'source <afile> | PackerSync',
        group = packer_group,
        pattern = 'plugins.lua'
    }
)

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
local function get_config(name)
    return string.format("require(\"config/%s\")", name)
end

vim.cmd [[packadd packer.nvim]]
return require('packer').startup({function()
    local use = require("packer").use
    -- manage packer
    use {
        "wbthomason/packer.nvim",
        opt = true,
    }

    -- speed up load time
    use 'lewis6991/impatient.nvim'

    -- lspconfig
    use {"neovim/nvim-lspconfig", config = get_config("lspconfig")}

    use {
        "nvim-treesitter/nvim-treesitter",
        config = get_config("treesitter"),
        run = ":TSUpdate",
    }
    use { -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter',
    }
    use {"mrjones2014/nvim-ts-rainbow"} --configured in treesitter.lua
    use {"nvim-treesitter/nvim-treesitter-context"} --configured in treesitter.lua
    use {
        "ray-x/lsp_signature.nvim",
        config = function()
            require "lsp_signature".setup()
        end,
        requires = {"neovim/nvim-lspconfig"},
    }
    use {
        "simrat39/rust-tools.nvim",
        config = get_config("rust-tools"),
        ft = {"rust"},
    }
    use {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup {}
        end,
    }
    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            "rafamadriz/friendly-snippets",
            {'hrsh7th/cmp-buffer', after = 'nvim-cmp'},
            {'hrsh7th/cmp-path', after = 'nvim-cmp'},
            {'hrsh7th/cmp-cmdline', after = 'nvim-cmp'},
            {'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'},
            {'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp'},
        },
        config = get_config("cmp"),
        event = "InsertEnter",
    }
    use {
        'windwp/nvim-autopairs',
        requires = {"hrsh7th/nvim-cmp"},
        config = get_config("autopairs"),
        after = "nvim-cmp",
    }
    use {
        'abecodes/tabout.nvim',
        config = function()
            require('tabout').setup {}
            vim.api.nvim_set_keymap('i', '<C-e>', "<Plug>(TaboutMulti)", {silent = true, desc = "Exit from a matched block"})
        end,
            wants = {'nvim-treesitter'},
            after = {'nvim-cmp'}
        }
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require('lspsaga').setup({
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
            }
        )
        end,
    })
    -- Commentary
    use {
        'numToStr/Comment.nvim',
        config = get_config("Comment"),
        event = "BufReadPost",
    }
    -- Git
    -- Column signs
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = get_config("gitsigns"),
        event = "BufReadPost",
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = get_config('lualine'),
    }
    use {
        'akinsho/bufferline.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
        config = get_config('bufferline'),
        event = "TabEnter",
    }
    -- FZF
    use {
        'ibhagwan/fzf-lua',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = get_config("fzf"),
    }
    -- nvim-tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = get_config("nvim-tree"),
        keys = "<C-t>",
    }
    -- Languages
    use {
        'fatih/vim-go',
        config = get_config("vim-go"),
        ft = {"go"},
    }
    use {
        'Vimjas/vim-python-pep8-indent',
        ft = {"python"},
    }
    -- Colours
    use {
       "norcalli/nvim-base16.lua",
       config = get_config("base16"),
   }
   -- Random
   use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
   use {
       "folke/todo-comments.nvim",
       requires = "nvim-lua/plenary.nvim",
       config = function()
           require("todo-comments").setup {}
       end
   }
   use {
       "kylechui/nvim-surround",
       tag = "*",
       config = get_config("nvim-surround"),
       after = "nvim-cmp",
   }
   use {
       "asiryk/auto-hlsearch.nvim",
       config = function()
           require("auto-hlsearch").setup()
       end
   }
   use {
       "chentoast/marks.nvim",
       config = function()
           require("marks").setup {
               builtin_marks = { ".", "<", ">", "^" },
           }
       end
   }
   -- Search result virtual text
   use {
       "kevinhwang91/nvim-hlslens",
       config = get_config("hlslens")
   }
   -- show indent layers
   use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup()
        end
   }
   -- Testing
   use({
       "andythigpen/nvim-coverage",
       requires = "nvim-lua/plenary.nvim",
       config = function()
           require("coverage").setup {}
       end,
       cmd = "Coverage",
   })
end,
config = {
    package_root = package_root,
    compile_path = compile_path,
    display = {
        open_fn = require('packer.util').float,
    }
}})
