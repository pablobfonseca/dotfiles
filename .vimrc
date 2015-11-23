" Type <leader>sv to refresh .vimrc after making changes
set nocompatible              " be iMproved, required
filetype on
" ================ General Config ====================

let mapleader=','
scriptencoding utf-8            " utf-8 all the way
syntax on
set encoding=utf-8
set number                      "Line numbers are good
set splitbelow
set splitright
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set mouse-=a                    " Disable mouse click
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set guicursor=a:blinkon0        " Disable cursor blink
set cursorline                  " Set line on cursor
set visualbell                  " No sounds
set autowrite                   " Automatically :write before running commands
set autoread                    " Reload files changed outside vim
set diffopt+=vertical           " Always use vertical diffs
set textwidth=80
highlight ColorColumn ctermbg=white
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1

" Trigger autoread when changing buffers or coming back to vim in terminal.
au FocusGained,BufEnter * :silent! !

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

set wrapmargin=2

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

" Type zz to center the window
set scrolloff=7         "Start scrolling when we're 7 lines away from margins
set sidescrolloff=15
set sidescroll=1

"Toggle relative numbering, and set to absolute on loss of focus or insert mode
set rnu
autocmd FocusLost   * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()

" ================ Quicker window movement ===========================
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" ================ Search ===========================

nnoremap / /\v
vnoremap / /\v
set gdefault        " Never have to type /g at the end of search / replace again
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...

" ================ Mappings ====================

nnoremap <silent><leader><space> :silent :nohlsearch<CR>
nnoremap <silent><leader>ev :silent :e $MYVIMRC<CR>
nnoremap <silent><leader>sv :silent :so $MYVIMRC <cr>
" bind \ (backward slash) to grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" Disable arrows
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <Up> <Nop>
noremap <Down> <Nop>

noremap <silent><leader>cc :silent :CtrlPClearAllCaches <cr>

" Toggle Gundo
nnoremap <F2> :GundoToggle<CR>

" Scroll the viewport faster
nnoremap <C-e> 7<C-e>
nnoremap <C-y> 7<C-y>
vnoremap <C-e> 7<C-e>
vnoremap <C-y> 7<C-y>

" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" resize panes
nnoremap <silent> <Left> :vertical resize +5<cr>
nnoremap <silent> <Right> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

noremap <Leader>rr :call Rename()<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

noremap <space>e :e <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>v :vsplit <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>s :split <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>r :r <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <leader>ri :RunInInteractiveShell<space>

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

" Make arrow keys move visual blocks around
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()
vmap  <expr>  <C-D>    DVB_Duplicate()

" ================ Custom AutoCMDS ====================
" Save whenever switching windows or leaving vim. This is useful when running
" the tests inside vim without having to save all files first.
autocmd FocusLost,WinLeave * :silent! wa

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

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

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass,less setlocal iskeyword+=-

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
set wmh=0 " reduces splits to a single line 

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" AutoCommand settings
autocmd FileType gitcommit      setlocal spell textwidth=72
autocmd FileType Gemfile        set filetype=ruby

" Always show status line
set laststatus=2
" Respect modeline in files
set modeline
set modelines=4
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the current mode
set title

" set the runtime path to include Vundle and initialize

set runtimepath+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Ruby, Rails, Rake
NeoBundle 'tpope/vim-rails.git' 
NeoBundle 'vim-ruby/vim-ruby.git'

" Javascript
NeoBundle 'jelera/vim-javascript-syntax'

NeoBundle 'mattn/emmet-vim'
NeoBundle 'tomtom/tcomment_vim'

" Git related...
NeoBundle 'L9'
NeoBundle 'mattn/gist-vim'
NeoBundle 'airblade/vim-gitgutter'

" General text editing improvements...

NeoBundle 'Raimondi/delimitMate'
NeoBundle 'skwp/vim-easymotion'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'pablobfonseca/vim-dragvisuals'

" General vim improvements
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'mattn/webapi-vim.git'
NeoBundle 'rking/ag.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-endwise.git'
NeoBundle 'tpope/vim-surround.git'
"vim-misc is required for vim-session
NeoBundle 'xolox/vim-misc'
NeoBundle 'tmhedberg/matchit'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'christoomey/vim-run-interactive'
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'garbas/vim-snipmate'

" Text objects
NeoBundle 'coderifous/textobj-word-column.vim'
NeoBundle 'suan/vim-instant-markdown'

" Cosmetics, color scheme, Powerline...
NeoBundle "itchyny/lightline.vim"
" Diary, notes, whatever. It's amazing
NeoBundle 'vimwiki/vimwiki'

" Remapping the emmet leader key
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'
autocmd FileType html,css EmmetInstall


" Enable easymotion
let g:EasyMotion_leader_key = '<Leader>'

" All of your Plugins must be added before the following line
call neobundle#end()
filetype plugin indent on    " required

NeoBundleCheck

let g:gist_clip_command = 'pbcopy' "Using Gist will copy URL to clipboard automatically
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1"

" Set Vim Wiki to my Dropbox directory
let g:vimwiki_list = [{'path':'$HOME/Dropbox/vimwiki'}]

" Ruby vim
let g:ruby_indent_access_modifier_style = 'indent'

" ================ Functions ====================

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

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

function! ToggleNumbersOn()
  set nu!
  set rnu
endfunction
function! ToggleRelativeOn()
  set rnu!
  set nu
endfunction

" Use the silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_working_path_mode = 'r'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
