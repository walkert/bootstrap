local parsers = { "go", "markdown", "python", "rust", "terraform" }

-- Textobject queries, keyed by the mapping that selects/jumps to them.
local selections = {
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
}

local motions = {
    ["]]"] = { "goto_next_start", "@function.outer" },
    ["]m"] = { "goto_next_start", "@class.outer" },
    ["]M"] = { "goto_next_end", "@function.outer" },
    ["]["] = { "goto_next_end", "@class.outer" },
    ["[["] = { "goto_previous_start", "@function.outer" },
    ["[m"] = { "goto_previous_start", "@class.outer" },
    ["[M"] = { "goto_previous_end", "@function.outer" },
    ["[]"] = { "goto_previous_end", "@class.outer" },
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        -- `main` does not support lazy-loading, and highlighting is the first
        -- paint regardless.
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
            -- Context is a floating header, not part of the buffer render, so
            -- it can wait for the first paint.
            { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy" },
        },
        config = function()
            require("nvim-treesitter").install(parsers)

            require("nvim-treesitter-textobjects").setup {
                select = { lookahead = true },
                move = { set_jumps = true },
            }

            local select = require "nvim-treesitter-textobjects.select"
            local move = require "nvim-treesitter-textobjects.move"

            -- Highlighting and the textobject maps are both opt-in on `main`.
            -- Grouped with clear=true so re-running this config (`:Lazy
            -- reload`) replaces the handler rather than stacking another.
            --
            -- The maps are deliberately buffer-local. Neovim's own ftplugins
            -- define buffer-local `]] [[ ][ [] ]m [m ]M [M` for python, go,
            -- rust and markdown, which would beat global maps -- and the
            -- documented fix, `vim.g.no_plugin_maps`, is worse than the
            -- disease: the ftplugin then skips creating those maps but still
            -- lists them in `b:undo_ftplugin`, so every FileType event throws
            -- `E31: No such mapping` (24 per buffer, enough to kill the
            -- session). Setting ours buffer-locally from here runs after the
            -- ftplugin and wins on its own terms, with no flag needed.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
                pattern = parsers,
                callback = function(ev)
                    vim.treesitter.start()

                    for key, query in pairs(selections) do
                        vim.keymap.set({ "x", "o" }, key, function()
                            select.select_textobject(query, "textobjects")
                        end, { buffer = ev.buf })
                    end

                    for key, spec in pairs(motions) do
                        vim.keymap.set({ "n", "x", "o" }, key, function()
                            move[spec[1]](spec[2], "textobjects")
                        end, { buffer = ev.buf })
                    end
                end,
            })

            -- `incremental_selection` is gone from `main`, but Neovim 0.12
            -- ships the feature itself as `an`/`in` -- see
            -- :h treesitter-incremental-selection. Point the old keys at it.
            --
            -- <CR> is mapped in BOTH normal and visual mode on purpose: the
            -- old config bound it to `init_selection` *and*
            -- `scope_incremental`, so holding it down kept widening the
            -- selection. Normal-mode only would start the selection and then
            -- fall through to a literal <CR> (cursor down), collapsing it.
            vim.keymap.set("n", "<CR>", "van", { remap = true })
            vim.keymap.set("x", "<CR>", "an", { remap = true })
            vim.keymap.set("x", "<TAB>", "an", { remap = true })
            vim.keymap.set("x", "<S-TAB>", "in", { remap = true })
        end,
    },
}
