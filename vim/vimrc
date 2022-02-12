"
"        _
" __   _(_)_ __ ___
" \ \ / / | '_ ` _ \
"  \ V /| | | | | | |
"   \_/ |_|_| |_| |_|
"
" File: vimrc
" Author: Pablo Fonseca <pablofonseca777@gmail.com>
" Description: VIM Rocks!
" Source: http://github.com/pablobfonseca/dotfiles

let mapleader=","
let maplocalleader="-"

filetype off
filetype plugin indent on

autocmd!
set nocompatible

function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfunction

call plug#begin('~/.vim/plugged')

call s:SourceConfigFilesIn('rcplugins')

call plug#end()

call s:SourceConfigFilesIn('rcfiles')
