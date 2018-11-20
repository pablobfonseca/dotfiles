" Vim Seeing is Believing 
Plug 'hwartig/vim-seeing-is-believing'

function! WithoutChangingCursor(fn)
  let cursor_pos     = getpos('.')
  let wintop_pos     = getpos('w0')
  let old_lazyredraw = &lazyredraw
  let old_scrolloff  = &scrolloff
  set lazyredraw

  call a:fn()

  call setpos('.', wintop_pos)
  call setpos('.', cursor_pos)
  redraw
  let &lazyredraw = old_lazyredraw
  let scrolloff   = old_scrolloff
endfun

function! SibCleanAnnotations(scope)
  call WithoutChangingCursor(function('execute', [a:scope . "!seeing_is_believing --clean"]))
endfun

augroup seeingIsBelievingSettings
  autocmd!

  autocmd FileType ruby nmap <buffer> r<Enter> <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby xmap <buffer> r<Enter> <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby nmap <buffer> <leader>m <Plug>(seeing-is-believing-mark)
  " autocmd FileType ruby nmap <buffer> <leader><leader> <Plug>(seeing-is-believing-run)
  autocmd FileType ruby xmap <buffer> <leader>m <Plug>(seeing-is-believing-mark)
  " autocmd FileType ruby xmap <buffer> <leader><leader> <Plug>(seeing-is-believing-run)
  autocmd FileType ruby vmap <buffer> <Leader>cr :call SibCleanAnnotations("'<,'>")<CR>;

augroup END
