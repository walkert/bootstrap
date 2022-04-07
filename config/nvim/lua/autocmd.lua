-- Ensure the color displays immediately after leaving insert mode
vim.cmd[[au InsertLeave * redraw!]]
-- Red on lines with greater than 79 chars in Python
vim.cmd[[au BufWinEnter *.py let w:m2=matchadd('ErrorMsg', '\%>79v.\+', -1)]]
