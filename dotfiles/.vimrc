set nocompatible                        " Use Vim defaults
filetype off                            " Required by Vundle

" Include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'scrooloose/nerdcommenter.git'
Plugin 'scrooloose/nerdtree.git'
Plugin 'fatih/vim-go.git'
Plugin 'davidhalter/jedi-vim.git'
Plugin 'nvie/vim-flake8.git'
Plugin 'ervandew/supertab.git'
Plugin 'tpope/vim-fugitive.git'
Plugin 'vim-airline/vim-airline.git'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized.git'
Plugin 'airblade/vim-gitgutter.git'
Plugin 'vim-scripts/openssl.vim'

call vundle#end()

syntax on                               " Enable syntax highlighting
filetype plugin indent on               " Auto load the indent file for detected file types

set autoindent
set cursorline
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
set t_Co=256                            " Enforce 256 colour mode
set splitright                          " vsp opens to the right
set splitbelow                          " sp opens below

" Set statusline background to green
hi statusline ctermfg=LightGreen ctermbg=0
" Set omnicomplete colours
hi Pmenu cterm=bold ctermfg=189 ctermbg=24
hi PmenuSel cterm=bold ctermfg=24 ctermbg=189

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

" 2s for Javascript, Puppet and Ruby
au BufRead,BufNewFile *.js,*.pp,*.rb set ts=2 sw=2 sts=2

" Tabs
set showtabline=1                       " 1=ondemand, 2=always
map ,t <Esc>:tabnew<CR>
map ,T <Esc>:tabclose<CR>
" scroll through tabs using - and =
nmap - gT
nmap = gt
hi TabLineSel ctermfg=Black ctermbg=189
hi TabLine ctermfg=189 ctermbg=Black
hi TabLineFill ctermfg=Black

" Windows - shorten combo for switching windows
nnoremap <C-w> <C-w>w

" Escape - hit jj instead of escape to exit insert mode
inoremap jj <ESC>

" Hit qq to write/suspend
inoremap qq <ESC>:w! \| stop<CR>
nmap qq <ESC>:w! \| stop<CR>

" Hit qw to write
inoremap qw <ESC>:w!<CR>
nmap qw <ESC>:w!<CR>

" Hit qww to write/quit
inoremap qww <ESC>:wq!<CR>
nmap qww <ESC>:wq!<CR>

" Hit qd to delete the current buffer
inoremap qd <ESC>:bd<CR>
nmap qd <ESC>:bd<CR>


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
nmap <silent> <leader>d :bd<CR>

" Red on lines with greater than 79chars
au BufWinEnter *.py let w:m2=matchadd('ErrorMsg', '\%>79v.\+', -1)

autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Plugins

" vim-flake8 - call with F9
noremap <silent> <F9> :call Flake8()<CR>

" NERDTree
" Toggle NERDTree with Ctrl-t
noremap <silent> <C-t> :NERDTreeToggle<CR>
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
" Map it to <leader>g instead
au FileType go nmap <Leader>g <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" vim-jedi
" Remap 'usages' from <leader>n to <leader>u
let g:jedi#usages_command = "<leader>u"
" Don't auto-run jedi dot completion
let g:jedi#popup_on_dot = 0
" Don't display call signatures
let g:jedi#show_call_signatures = 0
" Open defs etc in tabs instead of buffers
let g:jedi#use_tabs_not_buffers = 1

" vim-fugitive
noremap <silent> <Leader>gd :Gdiff<CR>
noremap <silent> <Leader>gb :Gblame<CR>

" vim-gitgutter
noremap <silent> <Leader>gg :GitGitterToggle<CR>

" vim-airline
let g:airline_powerline_fonts = 1                           " Use the powerline glyphs
let g:airline_theme = "powerlineish"                        " Use the powerline theme
let g:airline#extensions#tabline#enabled = 1                " Enable the airline tabs
let g:airline#extensions#tabline#tab_nr_type = 1            " Show the tab number
let g:airline#extensions#tabline#show_close_button = 0      " Disable the close button

" Enable the solarized colorscheme
set bg=dark
colorscheme solarized
highlight Visual ctermfg=NONE

" Source overrides if present
let overrides = expand("~/.overrides.vim")
if filereadable(overrides)
    silent! execute 'source '.overrides
endif
