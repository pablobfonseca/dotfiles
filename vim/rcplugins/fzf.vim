" fzf.vim 
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

let g:fzf_files_options =
      \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

nnoremap <leader>gc :Files app/controllers<cr>
nnoremap <leader>gj :Files app/assets/javascripts<cr>
nnoremap <leader>gl :Files lib<cr>
nnoremap <leader>gm :Files app/models<cr>
nnoremap <leader>gs :Files spec<cr>
nnoremap <leader>gv :Files app/views<cr>
nnoremap <leader>gw :Files app/workers<cr>
nnoremap <leader>gh :Files app/helpers<cr>
nnoremap <leader>gy :Files app/assets/stylesheets<cr>
nnoremap <leader>gf :Files spec/factories<cr>

nnoremap <leader>rf :Files ~/.vim/rcfiles<cr>
nnoremap <leader>rp :Files ~/.vim/rcplugins<cr>
nnoremap <leader>df :Files ~/.dotfiles/vim<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fm :Maps<cr>
nnoremap <leader>fc :Commits<cr>
nnoremap gs :GFiles?<cr>
nnoremap <leader>bl :BLines<cr>
nnoremap <leader>fl :Lines<cr>
nnoremap <leader>fh :HelpTags<cr>

imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" vim: ft=vim
