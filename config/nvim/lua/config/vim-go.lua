local g = vim.g
-- Disable re-mapping gd
g.go_def_mapping_enabled = 0
-- Use goimports to do formatting on write
g.go_fmt_command = "goimports"
-- Show type info under the cursor
g.go_auto_type_info = 1
-- Halve the default update time for a quicker refresh
g.go_updatetime = 400
vim.cmd [[
  augroup go
    autocmd!
    " :GoTest
    autocmd FileType go nmap <leader>t  <Plug>(go-test)
    " :GoTestFunc
    autocmd FileType go nmap <leader>tf  <Plug>(go-test-func)
    " :GoRun
    autocmd FileType go nmap <leader>r  <Plug>(go-run)
    " :GoDef
    autocmd FileType go nmap <Leader>d <Plug>(go-def-vertical)
    " :GoCoverageToggle
    autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    " :GoMetaLinter
    autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)
    " :GoDoc in a vertical split
    autocmd FileType go nmap <Leader>do <Plug>(go-doc-vertical)
  augroup END
]]
