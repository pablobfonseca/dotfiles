-- Open diagnostics in a floating window
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float({border="rounded", focus=false})]]

vim.cmd [[command! -nargs=0 RestMode execute 'edit restmode' | set filetype=http buftype=nofile]]

-- create a command to copy the entire file content
vim.cmd [[command! -nargs=0 CopyFile execute 'normal! ggVGy']]
