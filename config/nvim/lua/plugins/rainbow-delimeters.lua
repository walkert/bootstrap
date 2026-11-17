return {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    -- DO NOT add `event = "VeryLazy"` here. Every other eager plugin in this
    -- config was deferred to cut startup, but this one attaches to buffers
    -- only via FileType and never back-fills buffers that are already open.
    -- Deferring it past the first paint means any file named on the command
    -- line (`nvim foo.py`) silently gets no delimiters at all -- measured 178
    -- highlight extmarks -> 0. It must load before the first buffer is read.
    config = function()
        require('rainbow-delimiters.setup').setup {}
    end
}
