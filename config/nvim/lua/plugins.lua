local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("config") .. "/pack/packer/start/packer.nvim"
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
function get_config(name)
    return string.format("require(\"config/%s\")", name)
end

vim.cmd [[packadd packer.nvim]]
return require('packer').startup({function()
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
    use {"p00f/nvim-ts-rainbow"} --configured in treesitter.lua
    use {"lewis6991/nvim-treesitter-context"} --configured in treesitter.lua
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
    }
    use {
        'windwp/nvim-autopairs',
        requires = {"hrsh7th/nvim-cmp"},
        config = get_config("autopairs"),
    }
    -- Commentary
    use {
        'preservim/nerdcommenter',
        config = get_config("nerdcommenter"),
    }
    -- Git
    -- Column signs
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = get_config("gitsigns")
    }
    -- Additional commands and airline integration for showing the branch
    use 'tpope/vim-fugitive'
    -- Used for airline integration only (signs disabled)
    use {
        'airblade/vim-gitgutter',
        config = get_config("gitgutter")
    }
    use 'rhysd/git-messenger.vim'
    -- Status
    use {
        'vim-airline/vim-airline',
        requires = {
            'vim-airline/vim-airline-themes',
        },
        config = get_config("airline"),
    }
    -- FZF
    use {
        'ibhagwan/fzf-lua',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = get_config("fzf"),
    }
    -- nvim-tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = get_config("nvim-tree")
    }
    -- pounce
    use {
        'rlane/pounce.nvim',
        config = get_config("pounce")
    }
    -- Languages
    use {
        'fatih/vim-go',
        config = get_config("vim-go"),
        ft = {"go"},
    }
    use {
        "hashivim/vim-terraform",
        ft = {"terraform"},
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
end,
config = {
    package_root = package_root,
    compile_path = compile_path,
    display = {
        open_fn = require('packer.util').float,
    }
}})
