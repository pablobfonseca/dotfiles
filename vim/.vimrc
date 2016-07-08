" vim: foldmethod=marker
" File: .vimrc
" Author: Pablo Fonseca <pablofonseca777@gmail.com>
" Description: This is my amazing .vimrc
" Last Modified: July 07, 2016

" Preamble ---------------------- {{{
filetype off
filetype plugin indent on
" }}}

autocmd!

set nocompatible
colorscheme hipster

" Plugins ---------------------- {{{
call plug#begin('~/.vim/plugged')
Plug 'rking/ag.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'mattn/emmet-vim'
Plug 'ervandew/supertab'
Plug 'tomtom/tcomment_vim'
Plug 'coderifous/textobj-word-column.vim'
Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
Plug 'jlanzarotta/bufexplorer'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', { 'for': ['ruby', 'haml', 'slim'] }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'marcweber/vim-addon-mw-utils' | Plug 'garbas/vim-snipmate'
Plug 'tomtom/tlib_vim'
Plug 'slim-template/vim-slim', { 'for': 'slim' }
Plug 'klen/python-mode', { 'for': 'python' }
Plug 'mattn/webapi-vim'
Plug 'heavenshell/vim-slack'
Plug 'airblade/vim-gitgutter'
Plug 'easymotion/vim-easymotion'

if executable('tmux')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'benmills/vimux'
endif

call plug#end()

" }}}

" Abbreviations settings ---------------------- {{{

iabbrev pry binding.pry
" }}}

" General settings ---------------------- {{{

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enouth that CtrlP doesn't need to cache
  let g:ctrlp_user_caching = 0
endif

set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=500 " keep 500 lines of command history
set undolevels=500
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set showmatch
set wrap
set hidden
set mouse-=a
set secure
set noerrorbells
set ttyfast
set splitbelow
set splitright
set wrapmargin=0
set autoread
set re=1
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
set dictionary=~/.vim/spell/eng.utf-8.add
set textwidth=80
set colorcolumn=+1

let g:ruby_path = system('rvm current')

" Make the omnicomplete text readable
highlight PmenuSel ctermfg=black

" Ignore stuff that can't be opened
set wildignore+=tmp/**

" Highlight the status line
highlight StatusLine ctermfg=blue ctermbg=yellow

set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

" Disable K looking stuff up
nnoremap K <Nop>

" Better? completion on command line
set wildmenu wildmode=list:full

" (Hopefully) removes the delay when hitting esc in insert mode
set noesckeys
set ttimeout
set ttimeoutlen=1

" Make CtrlP use ag for listing the files. Way faster and no useless files.
" Without --hidden, it never finds .travis.yml since it starts with a dot
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0

" Don't wait so long for the next keypress (particularly in ambigious Leader
" situations.
set timeoutlen=500

" Setting Ctags
set tags+=.git/tags

" Make it more obvious which paren I'm on
hi MatchParen cterm=none ctermbg=black ctermfg=yellow

let g:vimrubocop_config = '~/code/Bizneo/bizneo/rubocop.yml'

" }}}

" Mappings ---------------------- {{{
let mapleader=','
let maplocalleader = "\\"

nnoremap K :grep! "\b<C-r><C-w>\b"<cr>:cw<cr>

" Resize full horizontally
nnoremap <leader>fl <C-w>|

" Resize full vertically
nnoremap <leader>fl <C-w>_

" Resize equal
nnoremap <leader>= <C-w>=

" Git gutter
nnoremap <Leader>hv <Plug>GitGutterPreviewHunk

nnoremap L $

" Open current html file into firefox
nnoremap <leader>of :!open -a "Firefox" %<tab><cr>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]''`']`

" Change vertically split to horizonally
nnoremap <leader>fh <C-w>t<C-w>K

" Change horizonally split to vertically
nnoremap <leader>fv <C-w>t<C-w>H

" Fugitive
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gp :Gpush<cr>

" Map Y to yank from the cursor position until the end of the line
map Y y$

" Insert a caller into Ruby code
nnoremap <leader>wtf oputs "#" * 90<c-m>puts caller<c-m>puts "#" * 90<esc>

" Source vimrc
nnoremap <silent><leader>sv :source $MYVIMRC<cr>
" Edit vimrc
nnoremap <silent><leader>ev :tabe $MYVIMRC<cr>

" Toggle paste mode on and off
nnoremap <leader>pp :setlocal paste!<cr>

" Update plugins
nnoremap <leader>pu :PlugUpdate<cr>

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

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
nnoremap <space>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
nnoremap <space>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <space>v :vsplit <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <space>r :r <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <space>t :tabe <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <Leader>sn :e ~/.vim/snippets/

nnoremap <silent><leader><space> :nohl<CR>
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<space>

" Close the quickfix window
nnoremap <space><space> :ccl<cr>

" Let's be reasonable, shall we?
nnoremap k gk
nnoremap j gj

" Coding notes
nnoremap <silent><leader>cn :!mvim ~/Dropbox/notes/coding-notes.md<cr>

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

" Vimux
nnoremap <silent><leader>vp :VimuxPromptCommand<cr>
nnoremap <silent><leader>vl :VimuxRunLastCommand<cr>

" Remap VIM 0 to first non-blank character
nnoremap 0 ^

" Remap yanking
nnoremap <leader>y "+y

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

" Generate ctags
nnoremap <Leader>rt :!ctags --tag-relative --extra=+f -Rf.git/tags --exclude=.git,pkg --languages=-javascript,sql<CR><CR>

" Remapping the emmet leader key
let g:user_emmet_leader_key='<C-Z>'
let g:user_emmet_mode='a'

" Enable easymotion
let g:EasyMotion_leader_key = '<Leader><Leader>'

" QUICKER WINDOW MOVEMENT
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" }}}

" Functions ---------------------- {{{

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

function! SearchForCallSitesCursor()
  let searchTerm = expand("<cword>")
  call SearchForCallSites(searchTerm)
endfunction

" Search for call sites for term (excluding its definition) and
" load into the quickfix list.
function! SearchForCallSites(term)
  cexpr system('ag ' . shellescape(a:term) . '\| grep -v def')
endfunction
" }}}

" Augroups ---------------------- {{{
augroup filetype_zsh
  " Clear old autocmds in group
  autocmd!
  " set shell syntax for zsh files
  autocmd FileType zsh set syntax=sh
augroup END

augroup filetype_python
  " Clear old autocmds in group
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal ai sw=4 sts=4 et fileformat=unix
  autocmd FileType python nnoremap <leader>py :!python %<Tab><cr>
  autocmd BufWritePre *.py :%s/\s\+$//e
augroup END

augroup filetype_ruby
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  " Make ?s part of words
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
  autocmd FileType gitcommit setlocal spell textwidth=72
  " Run the current ruby file
  autocmd FileType ruby nnoremap <leader>r :!ruby %<Tab><cr>
  " Remove trailing whitespace on save for ruby files.
  autocmd BufWritePre *.rb :%s/\s\+$//e
augroup END

augroup filetype_markdown_and_txt
  " Clear old autocmds in group
  autocmd!
  " By default, vim thinks .md is Modula-2.
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  " Without this, vim breaks in the middle of words when wrapping
  autocmd FileType markdown setlocal nolist wrap lbr
  " Source markdown editor
  autocmd FileType markdown source ~/.vim/writter.vim
  " Turn on spell-checking in markdown and text.
  autocmd BufRead,BufNewFile *.md,*.txt setlocal spell
  " Don't display whitespaces
  autocmd BufNewFile,BufRead *.txt setlocal nolist
augroup END

augroup filetype_javascript
  " Clear old autocmds in group
  autocmd!
  " Set syntax javascript to coffee script files
  autocmd BufNewFile,BufReadPost *.coffee setlocal syntax=javascript
  autocmd FileType javascript nnoremap <leader>n :!node %<Tab><cr>
augroup END

augroup filetype_html
  " Clear old autocmds in group
  autocmd!
  " Install Emmet
  autocmd FileType html,css EmmetInstall
augroup END

augroup vim_stuff
  " Clear old autocmds in group
  autocmd!
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
  " Wrap the quickfix window
  autocmd FileType qf setlocal wrap linebreak
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
  autocmd BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}

" Extended text-objects ---------------------- {{{
let s:items = ["<bar>", "\\", "/", ":", ".", "*", "_"]
for item in s:items
  exe "nnoremap yi".item." T".item."yt".item
  exe "nnoremap ya".item." F".item."yf".item
  exe "nnoremap ci".item." T".item."ct".item
  exe "nnoremap ca".item." F".item."cf".item
  exe "nnoremap di".item." T".item."dt".item
  exe "nnoremap da".item." F".item."df".item
  exe "nnoremap vi".item." T".item."vt".item
  exe "nnoremap va".item." F".item."vf".item
endfor
" }}}

" Python mode settings ---------------------- {{{
let g:pymode_rope = 1

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"

" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0
" }}}
