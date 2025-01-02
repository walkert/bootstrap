return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local actions = require "fzf-lua.actions"
        require'fzf-lua'.setup {
            -- <CR> opens files in a new tab vs the current buffer
            actions = {
                files = {
                    ["default"] = actions.file_tabedit,
                }
            },
            git = {
                files = {
                    -- Show tracked and untracked files so we'll see newly
                    -- created files during the search
                    cmd = "git ls-files -c -o --exclude-standard"
                }
            },
            grep = {
                actions = {
                    ['ctrl-q'] = {
                        fn = actions.file_edit_or_qf,
                        prefix = 'select-all+'
                    },
                },
            },
        }
    end,
    keys = {
        {",,", "<cmd>lua require('fzf-lua').git_files()<CR>", desc = "Search Git Files"},
        {"<leader>gr", "<cmd>lua require('fzf-lua').grep_cword()<CR>", desc = "[GR]ep for the cursor word"},
        {"<leader>lg", "<cmd>lua require('fzf-lua').live_grep()<CR>", desc = "[L]ive [G]rep"},
        {"<leader>sb", "<cmd>lua require('fzf-lua').buffers()<CR>", desc = "[S]earch  [B]uffers"},
        {"<leader>sc", "<cmd>lua require('fzf-lua').command_history()<CR>", desc = "[S]earch  [C]ommands"},
        {"<leader>sf", "<cmd>lua require('fzf-lua').files()<CR>", desc = "[S]earch  [F]iles"},
        {"<leader>sh", "<cmd>lua require('fzf-lua').help_tags()<CR>", desc = "[S]earch  [H]elp"},
        {"<leader>sk", "<cmd>lua require('fzf-lua').keymaps()<CR>", desc = "[S]earch [K]eymaps"},
        {"<leader>sm", "<cmd>lua require('fzf-lua').marks()<CR>", desc = "[S]earch [M]arks"},
        {"<leader>sgc", "<cmd>lua require('fzf-lua').git_commits()<CR>", desc = "[S]earch  [G]it [C]ommits"},
        {"<leader>sgb", "<cmd>lua require('fzf-lua').git_bcommits()<CR>", desc = "[S]earch  [G]it [B]uffer Commits"},
    },
}
