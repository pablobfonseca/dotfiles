" File: .vimrc
" Author: Pablo Fonseca <pablofonseca777@gmail.com>
" Description: This is my amazing .vimrc
" Last Modified: March 29, 2016

if &compatible
  set compatible " Be iMproved
endif

set nocompatible
filetype off

" ========================================================================
" NeoBundle stuff
" ========================================================================
" set the runtime path to include NeoBundle and initialize
set runtimepath^=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'ervandew/supertab'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'skwp/greplace.vim'
NeoBundle 'skwp/vim-easymotion'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'tomtom/tcomment_vim'

" Tpope
NeoBundle 'tpope/vim-bundler'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-eunuch'

NeoBundle 'thoughtbot/vim-rspec'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'slim-template/vim-slim.git'
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'marcweber/vim-addon-mw-utils'

" Tmux
if executable('tmux')
  NeoBundle 'christoomey/vim-tmux-navigator'
  NeoBundle 'benmills/vimux'
endif

" Text objects
NeoBundle 'coderifous/textobj-word-column.vim'
NeoBundle 'suan/vim-instant-markdown'

" Colors
NeoBundle "nanotech/jellybeans.vim"

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

" Use the colorscheme from above
colorscheme jellybeans

" ========================================================================
" Ruby stuff
" ========================================================================
syntax on " Enable syntax highlighting

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  autocmd FileType ruby,eruby,yaml setlocal colorcolumn=80
  " Make ?s part of words
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
augroup END

" Enable built-in matchit plugin 
runtime macros/matchit.vim

" ========================================================================
" Mappings
" ========================================================================
let mapleader=','

" Rails mappings
nnoremap <leader>ec :Econtroller<cr>
nnoremap <leader>em :Emodel<cr>

" Fugitive
map <leader>gs :Gstatus<cr>
map <leader>gc :Gcommit<cr>

" Run the current ruby file
map <leader>r :!ruby %<Tab><cr>

nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>vi :tabe $MYVIMRC<cr>
map <leader>ni :NeoBundleInstall<cr>
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

nnoremap ; :
" Copy the entire file content to the clipboard
map <Leader>co mmggVG"*y`m
" Open code directory
map <Leader>ec :e ~/code/
" Git WIP
map <Leader>gw :!git add . && git commit -m 'WIP' && git push<cr>
" Indent the whole file
map <Leader>i mmgg=G`m
" Join all the lines
map <Leader>mf mmgqap`m:w<cr>

" Get Ctags
map <Leader>rt :!ctags --tag-relative --extra=+f -Rf.git/tags --exclude=.git,pkg --languages=-javascript,sql<CR><CR>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <space>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
map <space>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <space>v :vsplit <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <space>r :r <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <Leader>sn :e ~/.vim/snippets/

map <silent><leader><space> :silent :nohl<cr>
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
map \ :Ag<space>

" Close the quickfix window
map <space><space> :ccl<cr>

" Let's be reasonable, shall we?
nmap k gk
nmap j gj

nnoremap <silent><leader>gb :silent :Gblame<CR>

" resize panes
nnoremap <silent> <Left> :vertical resize +5<cr>
nnoremap <silent> <Right> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" Coding notes
map <silent><leader>cn :tabe ~/Dropbox/notes/coding-notes.md<cr>

" Disable arrows
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Remap VIM 0 to first non-blank character
map 0 ^

" Remap yanking
map <space>y "+y

" Scroll the viewport faster
nnoremap <C-e> 7<C-e>
nnoremap <C-y> 7<C-y>
vnoremap <C-e> 7<C-e>
vnoremap <C-y> 7<C-y>

" Disable mouse scroll wheel
nmap <ScrollWheelUp> <nop>
nmap <S-ScrollWheelUp> <nop>
nmap <C-ScrollWheelUp> <nop>
nmap <ScrollWheelDown> <nop>
nmap <S-ScrollWheelDown> <nop>
nmap <C-ScrollWheelDown> <nop>
nmap <ScrollWheelLeft> <nop>
nmap <S-ScrollWheelLeft> <nop>
nmap <C-ScrollWheelLeft> <nop>
nmap <ScrollWheelRight> <nop>
nmap <S-ScrollWheelRight> <nop>
nmap <C-ScrollWheelRight> <nop>

" Remapping the emmet leader key
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'

" Enable easymotion
let g:EasyMotion_leader_key = '<Leader><Leader>'

""""""""""""""""""""""""""""""""""""""""""""""""""""
" QUICKER WINDOW MOVEMENT
"""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" ========================================================================
" General stuff
" ========================================================================
scriptencoding utf-8 " utf-8 all the way
set encoding=utf-8 nobomb
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=500 " keep 500 lines of command history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set showmatch
set hidden
set mouse-=a
set noerrorbells
set ttyfast
set splitbelow
set splitright
set wrap
set wrapmargin=0
set autoread
set wmh=0
set viminfo+=!
set guioptions-=T
set guifont=Hack:h13
set expandtab
set re=2
set sw=2
set smarttab
set incsearch
set hlsearch
set ignorecase smartcase
set laststatus=2 " Always shows the status line
set relativenumber
set gdefault " assume the /g flag on :s substitutions to replace all matches in a line
set autoindent
set lazyredraw " Don't redraw screen when running macros.
set scrolloff=7         "Start scrolling when we're 7 lines away from margins
set sidescrolloff=15
set sidescroll=1
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
" This makes RVM work inside Vim. I have no idea why.
set shell=bash

set nobackup
set nowritebackup
set noswapfile  " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps

let g:ruby_path = system('rvm current')

" Use Silver Searcher instead of grep
set grepprg=ag

" Make the omnicomplete text readable
highlight PmenuSel ctermfg=black

" Ignore stuff that can't be opened
set wildignore+=tmp/**

" Highlight the status line
highlight StatusLine ctermfg=blue ctermbg=yellow

" Format xml files
au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

set nofoldenable " Say no to code folding...

" Disable K looking stuff up
map K <Nop>

au BufNewFile,BufRead *.txt setlocal nolist " Don't display whitespace

" Better? completion on command line
set wildmenu
" What to do when I press 'wildchar'. Worth tweaking to see what feels right.
set wildmode=list:full

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1

" Turn on spell-checking in markdown and text.
au BufRead,BufNewFile *.md,*.txt setlocal spell

" Make CtrlP use ag for listing the files. Way faster and no useless files.
" Without --hidden, it never finds .travis.yml since it starts with a dot
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0

" Don't wait so long for the next keypress (particularly in ambigious Leader
" situations.
set timeoutlen=500

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e

" Set gutter background to black
highlight SignColumn ctermbg=black

" Setting Ctags
set tags+=.git/tags

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <Leader>rr :call RenameFile()<cr>

" Make it more obvious which paren I'm on
hi MatchParen cterm=none ctermbg=black ctermfg=yellow

" By default, vim thinks .md is Modula-2.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Install Emmet
autocmd FileType html,css EmmetInstall

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Without this, vim breaks in the middle of words when wrapping
autocmd FileType markdown setlocal nolist wrap lbr

" Wrap the quickfix window
autocmd FileType qf setlocal wrap linebreak

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HELPER FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
