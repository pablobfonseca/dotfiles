" Unite.vim - Unite and create user interfaces

Plug 'Shougo/unite.vim'

nnoremap <C-p> :Unite -no-split -buffer-name=files -start-insert -auto-highlight -auto-preview file_rec/async:!<cr>

" Grep
nnoremap <space>/ :Unite grep:.<cr>

" Switch buffer
nnoremap <space>b :Unite -quick-match -start-insert buffer<cr>

" vim: ft=vim
