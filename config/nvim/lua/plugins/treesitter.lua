return {
    {
        "nvim-treesitter/nvim-treesitter",
        -- Pinned to the archived `master` branch. The `main` branch is a full,
        -- incompatible rewrite: no `nvim-treesitter.configs`, highlighting moves
        -- to `vim.treesitter.start()`, `ensure_installed` becomes an async
        -- `install()`, and `incremental_selection` is removed outright. Migrate
        -- deliberately, not as a side effect of `:Lazy update`.
        branch = "master",
        dependencies = {
            -- Also pinned: textobjects has its own `main` rewrite and must move
            -- in lockstep with nvim-treesitter, not ahead of it.
            { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
            -- Context is a floating header, not part of the buffer render, so
            -- it can wait for the first paint. nvim-treesitter itself stays
            -- eager: highlighting *is* the first paint.
            { "nvim-treesitter/nvim-treesitter-context", event = "VeryLazy" },
        },
        build = ":TSUpdate",
        config = function()
            -- Since nvim 0.10, a query match maps capture ids to *lists* of
            -- TSNode rather than a single TSNode, and nvim 0.12 no longer
            -- honours the `{ all = false }` opt that used to restore the old
            -- shape. The archived `master` branch still assumes bare nodes, so
            -- every consumer of a prepared match calls a TSNode method on a
            -- plain table and throws -- `:start()` in tsrange.from_nodes for
            -- `#make-range!` captures, `:range()` in the textobjects move
            -- filter for plain ones. That breaks ]] / [[ / ]m / [m motions and
            -- the aa/ia/af/if/ac/ic selections.
            --
            -- Unlike the markdown case below there is no runtime fallback:
            -- Neovim ships no textobjects queries. Every capture reaches the
            -- prepared match through insert_to_path, so normalise there --
            -- one choke point rather than chasing each consumer.
            -- Remove this once the `main` migration lands.
            -- A TSNode has a `range` method; a list of nodes does not.
            local function as_node(v)
                if type(v) == "table" and v.range == nil and #v > 0 then
                    return v[#v]
                end
                return v
            end

            -- Plain captures reach the prepared match via insert_to_path...
            local tsquery = require "nvim-treesitter.query"
            local insert_to_path = tsquery.insert_to_path
            tsquery.insert_to_path = function(object, path, value)
                return insert_to_path(object, path, as_node(value))
            end

            -- ...but `#make-range!` captures bypass it, handing raw match
            -- values straight to TSRange.from_nodes, so patch that too.
            local tsrange = require "nvim-treesitter.tsrange"
            local from_nodes = tsrange.TSRange.from_nodes
            tsrange.TSRange.from_nodes = function(buf, start_node, end_node)
                return from_nodes(buf, as_node(start_node), as_node(end_node))
            end

            -- Same 0.10 node-list breakage again, but in the plugin's *query
            -- directives*. Each of these does `local node = match[capture_id]`
            -- and hands the result to get_node_text(), which calls
            -- `node:range()` -- so a list throws "attempt to call method
            -- 'range' (a nil value)" on every parse of an affected language.
            --
            -- This is not one language's problem: `#downcase!` alone is used
            -- by the hcl/terraform, html and vue injections (terraform gets it
            -- via `; inherits: hcl`, so opening any .tf file with a heredoc
            -- crashes the highlighter). Rather than shim per-language the way
            -- the markdown case below has to, re-register the directives with
            -- the match normalised -- one wrapper, every caller fixed.
            --
            -- Neovim keeps its directive table file-local and offers no getter,
            -- and query_predicates.lua returns nothing -- it registers its
            -- handlers as anonymous functions at require time. So the only
            -- place to reach them is in flight: wrap add_directive, let the
            -- module register as usual, and normalise the match on the way
            -- into each affected handler.
            -- Remove this once the `main` migration lands.
            local tsq = vim.treesitter.query
            local broken = {
                ["downcase!"] = true,
                ["set-lang-from-info-string!"] = true,
                ["set-lang-from-mimetype!"] = true,
                ["gsub!"] = true,
            }
            local add_directive = tsq.add_directive
            tsq.add_directive = function(name, handler, opts)
                if broken[name] then
                    local inner = handler
                    handler = function(match, ...)
                        local normalised = {}
                        for id, value in pairs(match) do
                            normalised[id] = as_node(value)
                        end
                        return inner(normalised, ...)
                    end
                end
                return add_directive(name, handler, opts)
            end

            -- Force the registrations to happen now, under the wrapper, then
            -- put the original function back so nothing else is affected.
            package.loaded["nvim-treesitter.query_predicates"] = nil
            require "nvim-treesitter.query_predicates"
            tsq.add_directive = add_directive

            -- The archived `master` branch ships a markdown injections query
            -- using `#set-lang-from-info-string!`. That directive indexes
            -- `match[capture_id]` as a bare TSNode, but since nvim 0.10 match
            -- values are *lists* of nodes, so it calls `:range()` on a plain
            -- table and throws. It fires whenever markdown is parsed --
            -- LSP hover (shift-K), Lspsaga, signature help.
            --
            -- The plugin's queries/ dir precedes $VIMRUNTIME on runtimepath, so
            -- its broken copy shadows Neovim's. Neovim 0.12 ships an equivalent
            -- query that captures @injection.language directly and needs no
            -- directive, so explicitly install the runtime's copy over it.
            -- (Setting an empty query would disable markdown injections
            -- altogether -- no highlighting in fenced code blocks.)
            -- Remove this once the `main` migration lands.
            local injections = vim.api.nvim_get_runtime_file(
                "queries/markdown/injections.scm", true
            )
            for _, path in ipairs(injections) do
                if not path:match("nvim%-treesitter") then
                    local fd = io.open(path, "r")
                    if fd then
                        vim.treesitter.query.set("markdown", "injections", fd:read("*a"))
                        fd:close()
                        break
                    end
                end
            end

            require'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = false,
                },
                ensure_installed = {
                    "go",
                    "markdown",
                    "python",
                    "rust",
                    "terraform",
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
