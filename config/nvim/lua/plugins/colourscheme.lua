return {
    "norcalli/nvim-base16.lua",
    config =function ()
        local base16 = require 'base16'
        base16(base16.themes.onedark, false)
    end
}
