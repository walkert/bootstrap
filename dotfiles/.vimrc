set nocompatible                        " Use Vim defaults

" Use vim-pathogen
set rtp+=$MYENV/vim
execute pathogen#infect()

syntax on                               " Enable syntax highlighting
filetype plugin indent on               " Auto load the indent file for detected file types

set autoindent
set expandtab                           " Convert tabs into spaces
set tabstop=4                           " Tab counts for 4 spaces
set shiftwidth=4                        " (Auto)indent counts for 4 spaces
set shiftround                          " Use multiples of shiftwidth when indenting with > or <
set softtabstop=4                       " Tab counts for 4 spaces in edit mode
set ignorecase                          " Ignore case in search patterns
set smartcase                           " But, observe case if an upper-case character is used
set scrolloff=3                         " Retain 3 lines above/below the cursor (for context)
set hidden                              " Hide buffers instead of closing them to allow switching between buffers even during writes
set backspace=indent,eol,start          " Allow backspace to be used in insert mode correctly
set pastetoggle=<C-o>                   " Ctrl-o to enable paste mode - prevents auto-indent during paste
set formatoptions+=ro                   " Auto-comment subsequent comment lines
set modelines=0                         " Disable modelines
set hlsearch                            " Enable search highlighting

" Set statusline background to green
hi statusline ctermfg=LightGreen ctermbg=0

" Add some useful information to the bottom of the page (requires
" laststatus=2)
set laststatus=2
set statusline=:%f                      " File name
set statusline+=%h                      " Help file flag
set statusline+=%m                      " Modified flag
set statusline+=%r                      " Read-only flag
set statusline+=\ \ \ \ %l\ \|\ %c      " Line | Column
set statusline+=\ %=                    " Align everyhing before this to the left
set statusline+=\ %{fugitive#statusline()}
set statusline+=\ [TYPE=%Y]             " Filetype
set statusline+=\ [LINE=%l/%L][%p%%]    " Line X of Y [% of file]
set statusline+=\ [COL=%c]              " Current column
set statusline+=\ [BUF=%n]              " File buffer

" Create a highlight group for use with matching unwanted characters
highlight BadWhitespace ctermbg=red guibg=red
" Match trailing whitespace at the end of a line - except while typing
match BadWhitespace /\s\+\%#\@<!$/
" Ensure the color displays immediately after leaving insert mode
autocmd InsertLeave * redraw!

" Wrap text after a certain 79 characters
au BufRead,BufNewFile *.py,*.pyw set textwidth=79

" 2s for Puppet
au BufRead,BufNewFile *.pp set ts=2 sw=2 sts=2

" Tabs
set showtabline=1                       " 1=ondemand, 2=always
map ,t <Esc>:tabnew<CR>
map ,T <Esc>:tabclose<CR>
" scroll through tabs using - and =
nmap - gT
nmap = gt
hi TabLineSel ctermfg=White ctermbg=LightBlue
hi TabLine ctermfg=White ctermbg=Black

" Windows - shorten combo for switching windows
nnoremap <C-w> <C-w>w

" Escape - hit jj instead of escape to exit insert mode
inoremap jj <ESC>

" Hit qq to write/suspend from insert mode
inoremap qq <ESC>:w! \| stop<CR>

" Hit qq to write/suspend from normal mode
nmap qq <ESC>:w! \| stop<CR>

" Hit qw to write from insert mode
inoremap qw <ESC>:w!<CR>

" Hit qw to write from normal mode
nmap qw <ESC>:w!<CR>

" Leader combos
let mapleader = ","                     "Set the <leader> to comma
" Switch off highlighted searches
nmap <silent> <leader>n :silent :nohlsearch<CR>
" Toggle list/nolist
nmap <silent> <leader>l :set list<CR>
nmap <silent> <leader>ll :set nolist<CR>
" Quicker quit
nmap <silent> <leader>q :q!<CR>
" Quicker write-quit
nmap <silent> <leader>wq :wq!<CR>
" Shift the current line 1 indent right
nmap <silent> <leader>. V>
" Shift the current line 1 indent left
nmap <silent> <leader>m V<
" Select the lines just pasted
nmap <silent> <leader>v V`]
" Quote the current word
nmap <silent> <leader>' viw<Esc>a'<Esc>gvO<Esc>i'<Esc>
nmap <silent> <leader>" viw<Esc>a"<Esc>gvO<Esc>i"<Esc>

" Buffers
" Use ctrl-n/ctrl-p to jump between buffers
nmap <c-n> :bnext<CR>
nmap <c-p> :bprev<CR>

" Red on lines with greater than 79chars
syntax match Search /\%<80v.\%>77v/
syntax match ErrorMsg /\%>79v.\+/
au BufRead,BufNewFile * syntax match Search /\%<80v.\%>77v/
au BufRead,BufNewFile * syntax match ErrorMsg /\%>79v.\+/

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Plugins

" vim-flake8 - call with F9
noremap <silent> <F9> :call Flake8()<CR>

" NERDTree
" Toggle NERDTree with Ctrl-t
map <C-t> :NERDTreeToggle<CR>
" Disable utf-8 characters (arrows) in the tree output
let g:NERDTreeDirArrows=0
" Show hidden files by default
let g:NERDTreeShowHidden=1
" Close NERDTree after opening a file
let NERDTreeQuitOnOpen = 1

" supertab
let g:SuperTabDefaultCompletionType = "context"

" vim-go
" Disable re-mapping gd
let g:go_def_mapping_enabled = 0
" Map it to <leader>gd instead
au FileType go nmap <Leader>gd <Plug>(go-doc)

" vim-jedi
" Remap 'usages' from <leader>n to <leader>u
let g:jedi#usages_command = "<leader>u"
" Don't auto-run jedi dot completion
let g:jedi#popup_on_dot = 0
