set nocompatible              " be iMproved, required
filetype on
" ================ General Config ====================

let mapleader=','
scriptencoding utf-8          " utf-8 all the way
set encoding=utf-8
set number               "Line numbers are good
set splitbelow
set splitright
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set mouse-=a                    "Disable mouse click
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set guicursor=a:blinkon0        "Disable cursor blink
set cursorline                  " Set line on cursor
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set guifont=Inconsolata\ XL:h14,Inconsolata:h15,Monaco:17,Monospace
syntax on
set textwidth=80

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.

colorscheme vendetta

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Display tabs and trailing spaces visually
set list
set listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest,full
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

"
" ================ Scrolling ========================

set scrolloff=7         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...

" ================ Normal mode mappings ====================

nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :so $MYVIMRC <cr>
noremap <leader>a :Ag 

" ================ Custom AutoCMDS ====================
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd Filetype text setlocal textwidth=78
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off
augroup END


" Optimize for fast terminal connections
set ttyfast
" Add g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps

set viminfo+=! " make sure vim history works
map <C-J> <C-W>j<C-W>_ " open and maximize the split below
map <C-K> <C-W>k<C-W>_ " open and maximize the split above
set wmh=0 " reduces splits to a single line 

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" AutoCommand settings
autocmd FileType gitcommit      setlocal spell textwidth=72
autocmd FileType Gemfile        set ft=ruby

" Always show status line
set laststatus=2
" Respect modeline in files
set modeline
set modelines=4
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set title

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Bundles

" Ruby, Rails, Rake
Bundle "tpope/vim-rails.git" 
Bundle "vim-ruby/vim-ruby.git"

" Python
" Bundle "scrooloose/syntastic"
" Bundle "Yggdroot/indentLine"

" PHP
Bundle 'arnaud-lb/vim-php-namespace'

" Javascript
Bundle "pangloss/vim-javascript"
" Bundle "rodjek/vim-puppet"
Bundle 'jelera/vim-javascript-syntax'

Bundle 'mattn/emmet-vim'
Bundle 'tomtom/tcomment_vim'

" Git related...
Bundle 'L9'
Bundle "mattn/gist-vim"
Bundle 'airblade/vim-gitgutter'

" General text editing improvements...

Bundle "Raimondi/delimitMate"
Bundle "briandoll/change-inside-surroundings.vim.git"
Bundle "godlygeek/tabular"
Bundle "skwp/vim-easymotion"
Bundle "tpope/vim-bundler"
Bundle "terryma/vim-multiple-cursors"
Bundle "vim-scripts/vim-polyglot"

" General vim improvements
Bundle "kien/ctrlp.vim"
" Bundle 'MarcWeber/vim-addon-mw-utils'
" Bundle "tomtom/tlib_vim.git"
" Bundle "majutsushi/tagbar.git"
Bundle "mattn/webapi-vim.git"
Bundle "rking/ag.vim"
Bundle "sjl/gundo.vim"
Bundle "tpope/vim-endwise.git"
Bundle "tpope/vim-surround.git"
"vim-misc is required for vim-session
Bundle "xolox/vim-misc"

" Text objects
Bundle "austintaylor/vim-indentobject"
Bundle "coderifous/textobj-word-column.vim"
" Bundle "nathanaelkane/vim-indent-guides"
Bundle "suan/vim-instant-markdown"

" Cosmetics, color scheme, Powerline...
" Bundle 'ervandew/supertab'
Bundle "bling/vim-airline.git"
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" Remapping the emmet leader key
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'
autocmd FileType html,css EmmetInstall

" Enable easymotion
let g:EasyMotion_leader_key = '<Leader>'

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Disable mouse scroll wheel
:nmap <ScrollWheelUp> <nop>
:nmap <S-ScrollWheelUp> <nop>
:nmap <C-ScrollWheelUp> <nop>
:nmap <ScrollWheelDown> <nop>
:nmap <S-ScrollWheelDown> <nop>
:nmap <C-ScrollWheelDown> <nop>
:nmap <ScrollWheelLeft> <nop>
:nmap <S-ScrollWheelLeft> <nop>
:nmap <C-ScrollWheelLeft> <nop>
:nmap <ScrollWheelRight> <nop>
:nmap <S-ScrollWheelRight> <nop>
:nmap <C-ScrollWheelRight> <nop>

" Disable arrows
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <Up> <Nop>
noremap <Down> <Nop>

map <S-Right>e :e <C-R>=expand("%:p:h") . "/" <CR>
map <S-Right>t :tabe <C-R>=expand("%:p:h") . "/" <CR>
map <S-Right>v :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <S-Right>s :split <C-R>=expand("%:p:h") . "/" <CR>
map <S-Right>r :r <C-R>=expand("%:p:h") . "/" <CR>

" Runs javascript File on Node
noremap <leader>n :w\|:!node %<cr>
noremap <leader>p :w\|:!python %<cr>
noremap <leader>r :w\|:!ruby %<cr>

noremap <leader>cc :CtrlPClearAllCaches <cr>

let g:gist_clip_command = 'pbcopy'

" Ruby vim
let g:ruby_indent_access_modifier_style = 'indent'

" Rename current file
function! Rename()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

noremap <Leader>rr :call Rename()<CR>

" syntastic
let g:syntastic_python_checkers=['python', 'flake8']
let g:syntastic_python_flake8_post_args='--ignore=W391'
