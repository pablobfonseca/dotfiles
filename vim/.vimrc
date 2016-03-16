" This is Pablo Fonseca's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:

autocmd!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
set nocompatible          " be iMproved, required
scriptencoding utf-8            " utf-8 all the way
set encoding=utf-8 nobomb
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
set laststatus=2
set showmatch
set cursorline
set ruler
set mouse-=a
set cmdheight=1
set switchbuf=useopen
set showtabline=2
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set showcmd
set modeline
set modelines=4
set noerrorbells
set autoread
set lazyredraw
set number
set list listchars=tab:\ \ ,trail:·
set ttyfast
set viminfo+=!
set winminheight=0
set guifont=Hack:h13
set exrc
set secure
set diffopt+=vertical
" Fix slow O inserts
set timeout timeoutlen=1000 ttimeoutlen=100
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Insert only one space when joining lines that contain sentence-terminating  punctuation like `.`.
set nojoinspaces
" If a file is changed outside of vim, automatically reload it without " asking
set autoread
set splitbelow
set splitright

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Scrolling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Type zz to center the window
set scrolloff=7         "Start scrolling when we're 7 lines away from margins
set sidescrolloff=15
set sidescroll=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IDENTATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent
set copyindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set shiftround
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TURN OFF SWAP FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set nowritebackup
set noswapfile                  " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMPLETION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PERSISTENT UNDO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
color vendetta

""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent><leader>gb :silent :Gblame<CR>

nnoremap <silent><leader><space> :silent :nohlsearch<CR>
nnoremap <silent><leader>ev :silent :e $MYVIMRC<CR>
nnoremap <silent><leader>sv :silent :so $MYVIMRC <cr>
nnoremap ; :

command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" Disable arrows
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

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

" resize panes
nnoremap <silent> <Left> :vertical resize +5<cr>
nnoremap <silent> <Right> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" Rename the current file
noremap <Leader>rr :call Rename()<CR>

noremap <space>e :e <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>t :tabe <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>v :vsplit <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>s :split <C-R>=expand("%:p:h") . "/" <CR>
noremap <space>r :r <C-R>=expand("%:p:h") . "/" <CR>

" Indent all lines
map <Leader>i mmgg=G`m

" Open a file splitted
noremap <leader>se <C-w>f

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

map <leader>y "*y

""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""
" QUICKER WINDOW MOVEMENT
"""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""
" RELATIVE NUMBERS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set relativenumber
autocmd FocusLost   * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()

""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
" """""""""""""""""""""""""""""""""""""""""""""""""""""

" Save whenever switching windows or leaving vim. This is useful when running
" the tests inside vim without having to save all files first.
autocmd FocusLost,WinLeave * :silent! wa

augroup	vimrcEx
  autocmd!

  autocmd Filetype text setlocal textwidth=78
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd Filetype python set sw=4 sts=4 et

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
	\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif
  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END


" Trigger autoread when changing buffers or coming back to vim in terminal.
autocmd FocusGained,BufEnter * :silent! !
autocmd FileType Gemfile        set filetype=ruby
autocmd FileType html,css EmmetInstall

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" ===========[ Plugins ]===========

set runtimepath+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Ruby, Rails, Rake
NeoBundle 'tpope/vim-rails.git' 
NeoBundle 'vim-ruby/vim-ruby.git'
NeoBundle 'ecomba/vim-ruby-refactoring'

" Javascript
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'kchmck/vim-coffee-script'

NeoBundle 'mattn/emmet-vim'
NeoBundle 'tomtom/tcomment_vim'

" Git related...
NeoBundle 'L9'
NeoBundle 'mattn/gist-vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'tpope/vim-fugitive.git' 

" General text editing improvements...

NeoBundle 'Raimondi/delimitMate'
NeoBundle 'skwp/vim-easymotion'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'slim-template/vim-slim.git'

" General vim improvements
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'mattn/webapi-vim.git'
NeoBundle 'rking/ag.vim'
NeoBundle 'tpope/vim-endwise.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'garbas/vim-snipmate'

NeoBundle 'tmhedberg/matchit'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'benmills/vimux'

" Text objects
NeoBundle 'coderifous/textobj-word-column.vim'
NeoBundle 'suan/vim-instant-markdown'

call neobundle#end()         " required
filetype plugin indent on    " required

NeoBundleCheck

" Remapping the emmet leader key
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'

" Global replace configurations
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'

" Enable easymotion
let g:EasyMotion_leader_key = '<Leader><Leader>'

let g:gist_clip_command = 'pbcopy' "Using Gist will copy URL to clipboard automatically
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1"

" =======[ Functions ]==========
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
