" Unite.vim - Unite and create user interfaces

Plug 'Shougo/unite.vim'

let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
      \ '-i --vimgrep --hidden --ignore ' .
      \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''

" Grep
nnoremap <space>/ :Unite grep:.<cr>

" Switch buffer
nnoremap <space>b :Unite -quick-match -start-insert buffer<cr>

" vim: ft=vim
