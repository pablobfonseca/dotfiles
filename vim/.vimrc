" Type <leader>sv to refresh .vimrc after making changes
set nocompatible          " be iMproved, required
filetype off

" ===========[ General Config ]===========

let mapleader = ","
scriptencoding utf-8            " utf-8 all the way
set encoding=utf-8 nobomb
set backspace=indent,eol,start 	" Backspace deletes like most programs in insert mode
set history=100
set ruler                       " Show the cursor position all the time
set mouse-=a                    " Disable mouse click
set cursorline                  " Set line on the cursor
set showcmd                     " Display incomplete commands
set showmode                    " Display current mode down the bottom
set incsearch                   " Do incremental searching
set laststatus=2                " Always display the status line
set modeline
set modelines=4
set noerrorbells
set title
set autowrite                   " Automatically :write before running commands
set autoread                    " Reload files changed outside vim
set lazyredraw                  " Don't redraw  screen when running macros
set number
set list listchars=tab:\ \ ,trail:·
set ttyfast                     " Optimize for fast terminal connections
set gdefault                    " Add g flag to search/replace by default
set viminfo+=!                  " Make sure vimhistory works
set winminheight=0              " Reduces splits to a single line

colorscheme vendetta

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Make it obvious where 80 characters is
set textwidth=80
set wrap
set wrapmargin=0
set colorcolumn=+1
" highlight ColorColumn ctermbg=white

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" ===========[ Turn Off Swap Files ]===========
set nobackup
set nowritebackup
set noswapfile                  " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287

" ============[ Persistent Undo ]============
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ============[ Indentation ]============
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set shiftround

" ============[ Completion ]============
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

" ============[ Scrolling ]============
" Type zz to center the window
set scrolloff=7         "Start scrolling when we're 7 lines away from margins
set sidescrolloff=15
set sidescroll=1

"Toggle relative numbering, and set to absolute on loss of focus or insert mode
set relativenumber
autocmd FocusLost   * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()

" ============[ Quicker window movement ]============
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" ============[ Search ]============

nnoremap / /\v
vnoremap / /\v
set gdefault        " Never have to type /g at the end of search / replace again
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

" ===========[ Mappings ] ==============
nnoremap <silent><leader><space> :silent :nohlsearch<CR>
nnoremap <silent><leader>ev :silent :e $MYVIMRC<CR>
nnoremap <silent><leader>sv :silent :so $MYVIMRC <cr>
" Delete all the file and enter in the INSERT mode
nnoremap <silent><leader>ca ggVGc

command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>

" Disable arrows
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

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

" Coding notes
map <Leader>cn :e ~/Dropbox/notes/coding-notes.md<cr>

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

" ===========[ Custom AutoCMDS ]===========
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

" Enable seeing-is-believing mappings only for Ruby
augroup seeingIsBelievingSettings
  autocmd!

  autocmd FileType ruby nmap <buffer> <Enter> <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby xmap <buffer> <Enter> <Plug>(seeing-is-believing-mark-and-run)

  autocmd FileType ruby nmap <buffer> <F4> <Plug>(seeing-is-believing-mark)
  autocmd FileType ruby xmap <buffer> <F4> <Plug>(seeing-is-believing-mark)
  autocmd FileType ruby imap <buffer> <F4> <Plug>(seeing-is-believing-mark)

  autocmd FileType ruby nmap <buffer> <F5> <Plug>(seeing-is-believing-run)
  autocmd FileType ruby imap <buffer> <F5> <Plug>(seeing-is-believing-run)
augroup END

" Trigger autoread when changing buffers or coming back to vim in terminal.
autocmd FocusGained,BufEnter * :silent! !
autocmd FileType Gemfile        set filetype=ruby
autocmd FileType html,css EmmetInstall

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

set runtimepath+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Ruby, Rails, Rake
NeoBundle 'tpope/vim-rails.git' 
NeoBundle 'vim-ruby/vim-ruby.git'
NeoBundle 'ecomba/vim-ruby-refactoring'
NeoBundle 'hwartig/vim-seeing-is-believing'

NeoBundle 'honza/vim-snippets'

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

" General vim improvements
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'mattn/webapi-vim.git'
NeoBundle 'rking/ag.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-endwise.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'garbas/vim-snipmate'

NeoBundle 'tmhedberg/matchit'
NeoBundle 'christoomey/vim-tmux-navigator'

NeoBundle 'ajh17/VimCompletesMe'

" Text objects
NeoBundle 'coderifous/textobj-word-column.vim'
NeoBundle 'suan/vim-instant-markdown'

call neobundle#end()         " required
filetype plugin indent on    " required

NeoBundleCheck

" Remapping the emmet leader key
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'

" Vim Completes Me
let b:vcm_tab_complete='omni'

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
