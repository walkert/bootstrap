return {
  "luukvbaal/statuscol.nvim",
  -- Deliberately NOT deferred. This plugin defines the *geometry* of the
  -- gutter (two `auto = false` sign segments either side of the number), while
  -- gitsigns and the LSP only supply the signs that go in it. Loading it after
  -- the first paint means the first frame is drawn with a bare number column
  -- and the text visibly shifts right by two columns when it arrives. It costs
  -- ~2ms to load eagerly, which is the cheapest fix available -- the signs
  -- themselves can still arrive late, because the space is already reserved.
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
        segments = {
          {
            sign = {
              namespace = { "diagnostic/signs" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          {
            sign = {
              namespace = { "gitsign" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
            },
            click = "v:lua.ScSa",
          },
      }
    })
  end,
}
