set nocompatible              " be iMproved, required
filetype on
set so=7
let g:snips_author = "Pablo Fonseca"

" ================ General Config ====================

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
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set guifont=Inconsolata\ XL:h14,Inconsolata:h15,Monaco:17,Monospace

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.
let mapleader="\<Space>"

colorscheme distinguished

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

set wildmode=list,longest
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

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" Clear the search buffer when hitting return
nnoremap <cr> :nohlsearch<cr>

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
set cursorline

autocmd FileType gitcommit      setlocal spell textwidth=72
autocmd FileType Gemfile        set ft=ruby

" This tip is an improved version of the example given for :help last-position-jump.
" It fixes a problem where the cursor position will not be restored if the file only has a single line.
"
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session

" function! ResCur()
"   if line("'\"") <= line("$")
"     normal! g`"
"     return 1
"   endif
" endfunction
"
" augroup resCur
"   autocmd!
"   autocmd BufWinEnter * call ResCur()
" augroup END

" Configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

" Ruby
imap <c-l> <space>=><space>

" Make tabs as wide as two spaces
"	set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
"	set lcs=trail:·
" Highlight searches
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

" PHP
Bundle 'StanAngeloff/php.vim'

" Ruby, Rails, Rake
Bundle "tpope/vim-rails.git" 
Bundle "tpope/vim-rake.git"
Bundle "vim-ruby/vim-ruby.git"

" Javascript
Bundle "briancollins/vim-jst"
Bundle "pangloss/vim-javascript"
Bundle "rodjek/vim-puppet"
Bundle 'jelera/vim-javascript-syntax'
Bundle 'othree/javascript-libraries-syntax.vim'

Bundle 'mattn/emmet-vim'
Bundle 'tomtom/tcomment_vim'

" Git related...
Bundle "gregsexton/gitv"
Bundle 'L9'
Bundle "mattn/gist-vim"
Bundle "skwp/vim-git-grep-rails-partial"
Bundle "tjennings/git-grep-vim"
Bundle "tpope/vim-fugitive"
Bundle "tpope/vim-git"
Bundle 'airblade/vim-gitgutter'

" General text editing improvements...
Bundle "AndrewRadev/splitjoin.vim"
Bundle "Raimondi/delimitMate"
Bundle "briandoll/change-inside-surroundings.vim.git"
Bundle "garbas/vim-snipmate.git"
Bundle "godlygeek/tabular"
Bundle "honza/vim-snippets"
Bundle "nelstrom/vim-visual-star-search"
Bundle "skwp/vim-easymotion"
Bundle "tpope/vim-bundler"
Bundle "vim-scripts/IndexedSearch"
Bundle "vim-scripts/camelcasemotion.git"
Bundle "vim-scripts/matchit.zip.git"
Bundle "terryma/vim-multiple-cursors"
Bundle "vim-scripts/vim-polyglot"
Bundle 'jeetsukumaran/vim-buffergator'

" General vim improvements
Bundle "MarcWeber/vim-addon-mw-utils.git"
Bundle "kien/ctrlp.vim"
Bundle "tomtom/tlib_vim.git"
Bundle "majutsushi/tagbar.git"
Bundle "mattn/webapi-vim.git"
Bundle "rking/ag.vim"
Bundle "scrooloose/syntastic.git"
Bundle "sjl/gundo.vim"
Bundle "YankRing.vim"
Bundle "tpope/vim-abolish"
Bundle "tpope/vim-endwise.git"
Bundle "tpope/vim-ragtag"
Bundle "tpope/vim-repeat.git"
Bundle "tpope/vim-surround.git"
Bundle "tpope/vim-unimpaired"
Bundle "vim-scripts/AnsiEsc.vim.git"
Bundle "vim-scripts/AutoTag.git"
Bundle "sudo.vim"
"vim-misc is required for vim-session
Bundle "xolox/vim-misc"
Bundle "xolox/vim-session"
Bundle 'rizzatti/dash.vim'

" Text objects
Bundle "austintaylor/vim-indentobject"
Bundle "coderifous/textobj-word-column.vim"
Bundle "kana/vim-textobj-datetime"
Bundle "kana/vim-textobj-entire"
Bundle "kana/vim-textobj-function"
Bundle "kana/vim-textobj-user"
Bundle "nathanaelkane/vim-indent-guides"
Bundle "nelstrom/vim-textobj-rubyblock"
Bundle "thinca/vim-textobj-function-javascript"
Bundle "vim-scripts/argtextobj.vim"
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}

" Cosmetics, color scheme, Powerline...
Bundle 'ervandew/supertab'
Bundle "bling/vim-airline.git"
" Ex.: vim index.html:20 - Open file index into line 20
Bundle "bogado/file-line.git" 
Bundle 'mmozuras/vim-github-comment'
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

let g:github_user = 'pablobfonseca'
let g:github_comment_open_browser = 1

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

:let g:session_autoload = 'yes'
:let g:session_autosave = 'yes'

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

map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
" Syntastic
"
" " Enable autochecks
 let g:syntastic_check_on_open=1
 let g:syntastic_enable_signs=1
"
" " For correct works of next/previous error navigation
 let g:syntastic_always_populate_loc_list = 1
"
" " check json files with jshint
 let g:syntastic_filetype_map = { "json": "javascript", }
"
" " open quicfix window with all error found
 nmap <silent> <leader>ll :Errors<cr>
" " previous syntastic error
 nmap <silent> [ :lprev<cr>
" " next syntastic error
 nmap <silent> ] :lnext<cr>

" neocomplcache
"
" " Enable NeocomplCache at startup
 let g:neocomplcache_enable_at_startup = 1
"
" " Max items in code-complete
 let g:neocomplcache_max_list = 10
"
" " Max width of code-complete window
 let g:neocomplcache_max_keyword_width = 80
"
" " Code complete is ignoring case until no Uppercase letter is in input
 let g:neocomplcache_enable_smart_case = 1
"
" " Auto select first item in code-complete
let g:neocomplcache_enable_auto_select = 1
"
" " Disable auto popup
let g:neocomplcache_disable_auto_complete = 1

" Undo autocomplete
 inoremap <expr><C-e> neocomplcache#undo_completion()
"
" PHP
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>
map ,s :split <C-R>=expand("%:p:h") . "/" <CR>
