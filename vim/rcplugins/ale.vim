" Ale.vim - Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
Plug 'dense-analysis/ale'

let g:ale_linters = { 'javascript': ['xo'] }
let g:ale_fixers = { 'javascript': ['xo'] }

" vim:ft=vim
