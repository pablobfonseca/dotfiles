" Maintained by: Pablo Fonseca
" pablofonseca777@gmail.com


set nocompatible              " be iMproved, required
filetype off

" ================ General Config ====================

scriptencoding utf-8          " utf-8 all the way
set encoding=utf-8
set number               "Line numbers are good
set splitbelow
set splitright
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set guifont=Inconsolata\ XL:h17,Inconsolata:h20,Monaco:h17

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
let mapleader=","
colorscheme codeschool

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
" Change mapleader
let mapleader=","
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

autocmd FileType gitcommit setlocal colorcolumn=72

" This tip is an improved version of the example given for :help last-position-jump.
" It fixes a problem where the cursor position will not be restored if the file only has a single line.
"
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

" Ruby
imap <c-l> <space>=><space>

" RSpec
let g:rspec_command = "!bin/rspec {spec}"

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>

" Make tabs as wide as two spaces
"	set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
"	set lcs=trail:·
" Highlight searches
" Always show status line
set laststatus=2
" Respect modeline in files
set modeline
set modelines=4
" Enable mouse in all modes
set mouse=a
set mousehide
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set title

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Bundles

" Ruby, Rails, Rake
Bundle "astashov/vim-ruby-debugger"
Bundle "tpope/vim-rails.git" 
Bundle "tpope/vim-rake.git"
Bundle "vim-ruby/vim-ruby.git"
Bundle "vim-scripts/Specky.git"
Bundle "ck3g/vim-change-hash-syntax"

" Other languages
Bundle "briancollins/vim-jst"
Bundle "pangloss/vim-javascript"
Bundle "rodjek/vim-puppet"

" Html, Xml, Css, Markdown...
Bundle "claco/jasmine.vim"
Bundle "digitaltoad/vim-jade.git"
Bundle "groenewege/vim-less.git"
Bundle "itspriddle/vim-jquery.git"
Bundle "jtratner/vim-flavored-markdown.git"
Bundle "kchmck/vim-coffee-script"
Bundle "nelstrom/vim-markdown-preview"
Bundle "skwp/vim-html-escape"
Bundle "slim-template/vim-slim.git"
Bundle "timcharper/textile.vim.git"
Bundle "tpope/vim-haml"
Bundle "wavded/vim-stylus"
Plugin 'mattn/emmet-vim'
Plugin 'shemerey/vim-peepopen'

" Git related...
Bundle "gregsexton/gitv"
Bundle "mattn/gist-vim"
Bundle "skwp/vim-git-grep-rails-partial"
Bundle "tjennings/git-grep-vim"
Bundle "tpope/vim-fugitive"
Bundle "tpope/vim-git"

" General text editing improvements...
Bundle "AndrewRadev/splitjoin.vim"
Bundle "Raimondi/delimitMate"
Bundle "Shougo/neocomplcache.git"
Bundle "briandoll/change-inside-surroundings.vim.git"
Bundle "garbas/vim-snipmate.git"
Bundle "godlygeek/tabular"
Bundle "honza/vim-snippets"
Bundle "nelstrom/vim-visual-star-search"
Bundle "skwp/vim-easymotion"
Bundle "tomtom/tcomment_vim.git"
Bundle "tpope/vim-bundler"
Bundle "vim-scripts/IndexedSearch"
Bundle "vim-scripts/camelcasemotion.git"
Bundle "vim-scripts/matchit.zip.git"
Bundle "terryma/vim-multiple-cursors"

" General vim improvements
Bundle "MarcWeber/vim-addon-mw-utils.git"
Bundle "kien/ctrlp.vim"
Bundle "majutsushi/tagbar.git"
Bundle "mattn/webapi-vim.git"
Bundle "rking/ag.vim"
Bundle "scrooloose/syntastic.git"
Bundle "sjl/gundo.vim"
Bundle "skwp/YankRing.vim"
Bundle "tpope/vim-abolish"
Bundle "tpope/vim-endwise.git"
Bundle "tpope/vim-ragtag"
Bundle "tpope/vim-repeat.git"
Bundle "tpope/vim-surround.git"
Bundle "tpope/vim-unimpaired"
Bundle "vim-scripts/AnsiEsc.vim.git"
Bundle "vim-scripts/AutoTag.git"
Bundle "vim-scripts/sudo.vim"
"vim-misc is required for vim-session
Bundle "xolox/vim-misc"
Bundle "xolox/vim-session"

" Text objects
Bundle "austintaylor/vim-indentobject"
Bundle "bootleq/vim-textobj-rubysymbol"
Bundle "coderifous/textobj-word-column.vim"
Bundle "kana/vim-textobj-datetime"
Bundle "kana/vim-textobj-entire"
Bundle "kana/vim-textobj-function"
Bundle "kana/vim-textobj-user"
Bundle "lucapette/vim-textobj-underscore"
Bundle "nathanaelkane/vim-indent-guides"
Bundle "nelstrom/vim-textobj-rubyblock"
Bundle "thinca/vim-textobj-function-javascript"
Bundle "vim-scripts/argtextobj.vim"

" Cosmetics, color scheme, Powerline...
Bundle "chrisbra/color_highlight.git"
Bundle "skwp/vim-colors-solarized"
Bundle "bling/vim-airline.git"
Bundle "vim-scripts/TagHighlight.git"
Bundle "bogado/file-line.git"
Bundle "jby/tmux.vim.git"

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" plugin on GitHub repo
Plugin 'L9'
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

"Ack
Plugin 'mileszs/ack.vim'

Plugin 'ervandew/supertab'

"Markdown
Plugin 'tpope/vim-markdown'

"GitGutter
Plugin 'airblade/vim-gitgutter'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

:let g:session_autoload = 'no'
