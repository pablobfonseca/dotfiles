" fzf.vim 
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

let g:fzf_command_prefix = 'Fzf'

" Configure FZF to use a floating window configuration
let $FZF_DEFAULT_OPTS = '--layout=reverse'

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

autocmd! FileType fzf
autocmd FileType fzf set noshowmode noruler nonu

nnoremap <leader>f :Find<cr>
nnoremap <C-p> :AF<cr>
nnoremap <C-f> :FzfGitFiles<cr>
nnoremap <leader>gc :FzfFiles app/controllers<cr>
nnoremap <leader>gj :FzfFiles app/assets/javascripts<cr>
nnoremap <leader>gl :FzfFiles config/locales<cr>
nnoremap <leader>gm :FzfFiles app/models<cr>
nnoremap <leader>gs :FzfFiles spec<cr>
nnoremap <leader>gv :FzfFiles app/views<cr>
nnoremap <leader>gw :FzfFiles app/workers<cr>
nnoremap <leader>gh :FzfFiles app/helpers<cr>
nnoremap <leader>gsv :FzfFiles app/services<cr>
nnoremap <leader>gpr :FzfFiles app/presenters<cr>
nnoremap <leader>gy :FzfFiles app/assets/stylesheets<cr>
nnoremap <leader>gf :FzfFiles spec/factories<cr>

nnoremap <leader>rf :FzfFiles ~/.vim/rcfiles<cr>
nnoremap <leader>rp :FzfFiles ~/.vim/rcplugins<cr>
nnoremap <leader>df :FzfFiles ~/.dotfiles<cr>
nnoremap <leader>fb :FzfBuffers<cr>
nnoremap <leader>ft :FzfTags<cr>
nnoremap <leader>fm :FzfMaps<cr>
nnoremap <leader>fc :FzfCommits<cr>
nnoremap gs :FzfGFiles?<cr>
nnoremap <leader>bl :FzfBLines<cr>
nnoremap <leader>fh :FzfHelpTags<cr>
nnoremap <leader>fa :FzfRg<cr>

imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Configures ripgrep with fzf
command! -bang -nargs=* FzfRg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* Rgg call fzf#vim#grep("rg --no-ignore --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"   * Preview script requires Ruby
"   * Install Highlight or CodeRay to enable syntax highlighting
"
"   :FzfAg  - Start fzf with hidden preview window that can be enabled with "?" key
"   :FzfAg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* FzfAg
      \ call fzf#vim#ag(<q-args>,
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

command! -bang -nargs=? -complete=dir FzfFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" All files
command! -nargs=? -complete=dir AF
      \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
      \ 'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
      \ })))
nnoremap <leader>af :AF<cr>

" vim: ft=vim
