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
Plugin 'tpope/vim-fugitive.git'
Plugin 'vim-airline/vim-airline.git'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized.git'
Plugin 'airblade/vim-gitgutter.git'
Plugin 'vim-scripts/openssl.vim'
Plugin 'ternjs/tern_for_vim.git'
Plugin 'hashivim/vim-terraform'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'neoclide/coc.nvim'

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
set number                              " Show line numbers
set relativenumber                      " Use relative line numbers instead
set autoread                            " Watch for external file changes


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

" Avoid ex mode
nnoremap Q <nop>

" Goto file in a new tab
nnoremap gf <C-W>gf

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

" vim-go
" Disable re-mapping gd
let g:go_def_mapping_enabled = 0
" Use goimports to do formatting on write
let g:go_fmt_command = "goimports"
" Show type info under the cursor
let g:go_auto_type_info = 1
" Halve the default update time for a quicker refresh
let g:go_updatetime = 400

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

" fzf
"
" Declare the Rg command using ripgrep with the word under the cursor as the argument
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ 'rg --hidden --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
  \ fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

" Map leader-leader to :Files
nnoremap <silent> <Leader><Leader> :Files<CR>
" Map leader-/ to :Files ~
nnoremap <silent> <Leader>h :Files ~<CR>
" Map leader-G to :Rg
nnoremap <silent> <Leader>gr :Rg <CR>

" coc
"
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" The CheckNext function checks to see what the next character is.
" If its a closing parenthesis, the cursor will advance to the right and the
" CR will be pressed. Otherwise, CR will be pressed.
function! CheckNext()
   let nextchar = strcharpart(getline('.')[col('.') - 1:], 0, 1)
   if nextchar == ")"
       call feedkeys("\<Right>\<CR>")
       return ''
   else
       return ''
   endif
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" !! This is a modified version of the above which passes the responsibility
" of sending <CR> to the CheckNext function described above. This is so that
" when hitting 'enter' when an auto-inserted closing parenthesis is in place,
" it will advance to the next line instead of moving the closer down with it.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : CheckNext()

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" End Plugins

" Enable the solarized colorscheme
let g:solarized_termtrans=1                                 " Required on OSX with transparent background
let g:solarized_termcolors=256                              " Required when using 256 color terminal on OSX
set bg=dark
:silent! colorscheme solarized
highlight Visual ctermfg=NONE
" Restore old SignColumn colours (broken by vim-gitgutter)
highlight! link SignColumn LineNr
" Create a highlight group for use with matching unwanted characters
highlight BadWhitespace ctermbg=red guibg=red
" Match trailing whitespace at the end of a line - except while typing
match BadWhitespace /\s\+\%#\@<!$/

" Set omnicomplete colours to match powerline theme
hi Pmenu cterm=bold ctermfg=117 ctermbg=24
hi PmenuSel cterm=bold ctermfg=24 ctermbg=117

" Source overrides if present
let overrides = expand("~/.overrides.vim")
if filereadable(overrides)
    silent! execute 'source '.overrides
endif
