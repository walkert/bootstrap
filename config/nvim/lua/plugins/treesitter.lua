return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "mrjones2014/nvim-ts-rainbow",
            "nvim-treesitter/nvim-treesitter-context",
        },
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = false,
                    disable = {},
                },
                ensure_installed = {
                    "go",
                    "markdown",
                    "python",
                    "rust",
                    "terraform",
                },
                rainbow = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                    init_selection = '<CR>',
                    scope_incremental = '<CR>',
                    node_incremental = '<TAB>',
                    node_decremental = '<S-TAB>',
                    },
                    is_supported = function ()
                        local mode = vim.api.nvim_get_mode().mode
                        if mode == "c" then
                        return false
                        end
                        return true
                    end,
                },
                -- nvim-treesitter-textobjects config
                textobjects = {
                    select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                    },
                    move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']]'] = '@function.outer',
                        [']m'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[['] = '@function.outer',
                        ['[m'] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                    },
                },
            }
        end
    },
}
