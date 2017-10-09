" Vim Tmux Runner - Vim and tmux

if executable('tmux')
  Plug 'christoomey/vim-tmux-runner'
endif

nnoremap <silent><leader>vp :VtrSendCommandToRunner!<cr>
nnoremap <silent><leader>vf :VtrFlushCommand<cr> :echo "The commands has been flushed"<cr>
nnoremap <leader>rs :call VtrSendCommand("clear; rspec " . bufname("%"))<CR>
nnoremap <leader>vz :VtrFocusRunner<cr>
nnoremap <leader>vq :VtrKillRunner<cr>
nnoremap <leader>vc :VtrClearRunner<cr>

" vim:ft=vim

