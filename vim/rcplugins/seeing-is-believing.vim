" Vim Seeing is Believing 
Plug 'hwartig/vim-seeing-is-believing'

augroup seeingIsBelievingSettings
  autocmd!

  autocmd FileType ruby nmap <buffer> <Enter> <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby xmap <buffer> <Enter> <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby nmap <buffer> <leader>m <Plug>(seeing-is-believing-mark)
  " autocmd FileType ruby nmap <buffer> <leader><leader> <Plug>(seeing-is-believing-run)
  autocmd FileType ruby xmap <buffer> <leader>m <Plug>(seeing-is-believing-mark)
  " autocmd FileType ruby xmap <buffer> <leader><leader> <Plug>(seeing-is-believing-run)
augroup END
