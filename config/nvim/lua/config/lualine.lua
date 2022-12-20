--local function my_location()
  --local line = vim.fn.line('.')
  --local col = vim.fn.virtcol('.')
  --local all = vim.fn.line('$')
  --return string.format('%d:%-3d/ %d', line, col, all)
--end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'powerline',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
        'branch',
        {
            'diff',
            --diff_color = {
                --removed = "GitGutterDelete",
            --}
        }
    },
    lualine_c = {
        {
            'filename',
            path = 1,
        },
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {
        --my_location,
        '%l:%c / %L',
        {
            'diagnostics',
            sources = {'nvim_diagnostic'},
            diagnostics_color = {
                warn = { fg = "#005f00"},
                hint = { fg = "#005f00"},
                info = { fg = "#005f00"},
            },
            colored = true,
        }
    }
  }
}
