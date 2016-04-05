call pathogen#infect()
call pathogen#helptags()

" File: .vimrc
" Author: Pablo Fonseca <pablofonseca777@gmail.com>
" Description: This is my amazing .vimrc
" Last Modified: April 5, 2016

set nocompatible

" ========================================================================
" Plugins
" ========================================================================
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin indent on

colorscheme vividchalk

" ========================================================================
" Ruby stuff
" ========================================================================
augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  " Make ?s part of words
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END

" Enable built-in matchit plugin 
runtime macros/matchit.vim

" ========================================================================
" Mappings
" ========================================================================
let mapleader=','
let maplocalleader = "\\"

" Rails mappings
nnoremap <leader>ec :Econtroller<cr>
nnoremap <leader>em :Emodel<cr>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]''`']`

" Fugitive
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>

" Run the current ruby file
nnoremap <leader>r :!ruby %<Tab><cr>

nnoremap <silent><leader>sv :source $MYVIMRC<cr>
nnoremap <silent><leader>ev :split $MYVIMRC<cr>
nnoremap <leader>ni :NeoBundleInstall<cr>
nnoremap <leader>nc :NeoBundleCheckUpdate<cr>
" Toggle paste mode on and off
nnoremap <leader>pp :setlocal paste!<cr>

nnoremap ; :
" Copy the entire file content to the clipboard
nnoremap <Leader>co mmggVG"*y`m
" Open code directory
nnoremap <Leader>ec :e ~/code/
" Git WIP
nnoremap <Leader>gw :!git add . && git commit -m 'WIP' && git push<cr>
" Indent the whole file
nnoremap <Leader>i mmgg=G`m
" Join all the lines
nnoremap <Leader>mf mmgqap`m:w<cr>

" Get Ctags
nnoremap <Leader>rt :!ctags --tag-relative --extra=+f -Rf.git/tags --exclude=.git,pkg --languages=-javascript,sql<CR><CR>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
nnoremap <space>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
nnoremap <space>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <space>v :vsplit <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <space>r :r <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <Leader>sn :e ~/.vim/snippets/

nnoremap <silent><leader><space> :nohl<CR>
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<space>

" Close the quickfix window
nnoremap <space><space> :ccl<cr>

" Let's be reasonable, shall we?
nnoremap k gk
nnoremap j gj

nnoremap <silent><leader>gb :silent :Gblame<CR>

" Coding notes
nnoremap <silent><leader>cn :tabe ~/Dropbox/notes/coding-notes.md<cr>

" Disable arrows
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" resize panes
nnoremap <silent> <Left> :vertical resize +5<cr>
nnoremap <silent> <Right> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Remap VIM 0 to first non-blank character
nnoremap 0 ^

" Remap yanking
nnoremap <space>y "+y

" Scroll the viewport faster
nnoremap <C-e> 7<C-e>
nnoremap <C-y> 7<C-y>
vnoremap <C-e> 7<C-e>
vnoremap <C-y> 7<C-y>

" Disable mouse scroll wheel
nnoremap <ScrollWheelUp> <nop>
nnoremap <S-ScrollWheelUp> <nop>
nnoremap <C-ScrollWheelUp> <nop>
nnoremap <ScrollWheelDown> <nop>
nnoremap <S-ScrollWheelDown> <nop>
nnoremap <C-ScrollWheelDown> <nop>
nnoremap <ScrollWheelLeft> <nop>
nnoremap <S-ScrollWheelLeft> <nop>
nnoremap <C-ScrollWheelLeft> <nop>
nnoremap <ScrollWheelRight> <nop>
nnoremap <S-ScrollWheelRight> <nop>
nnoremap <C-ScrollWheelRight> <nop>

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
set undolevels=500
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set showmatch
set hidden
set mouse-=a
set secure
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
set guifont=Source\ Code\ Pro:h13
set expandtab
set shiftwidth=2
set softtabstop=2
set smarttab
set incsearch
set hlsearch
set ignorecase smartcase
set laststatus=2 " Always shows the status line
set relativenumber
set gdefault " assume the /g flag on :s substitutions to replace all matches in a line
set autoindent
set copyindent
set lazyredraw " Don't redraw screen when running macros.
set scrolloff=7         "Start scrolling when we're 7 lines away from margins
set sidescrolloff=15
set sidescroll=1
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
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

set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

set nofoldenable " Say no to code folding...

" Disable K looking stuff up
nnoremap K <Nop>

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

" Setting Ctags
set tags+=.git/tags

nnoremap <Leader>rt :!ctags --tag-relative --extra=+f -Rf.git/tags --exclude=.git,pkg --languages=-javascript,sql<CR><CR>

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
nnoremap <Leader>rr :call RenameFile()<cr>

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

autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))

let g:vimrubocop_config = '~/code/Bizneo/bizneo/rubocop.yml'

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

function! RSpec()
  exec '!bin/rspec %'
endfunction
nnoremap <Leader>a :call RSpec()<cr>

function! s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

function! AlignSection(regex) range
  let extra = 1
  let sep = empty(a:regex) ? '=' : a:regex
  let maxpos = 0
  let section = getline(a:firstline, a:lastline)
  for line in section
    let pos = match(line, ' *'.sep)
    if maxpos < pos
      let maxpos = pos
    endif
  endfor
  call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
  call setline(a:firstline, section)
endfunction
command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>al :Align<CR>

function! AlignLine(line, sep, maxpos, extra)
  let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
  if empty(m)
    return a:line
  endif
  let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
  return m[1] . spaces . m[2]
endfunction
