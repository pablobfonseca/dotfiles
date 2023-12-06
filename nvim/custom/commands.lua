-- Open diagnostics in a floating window
-- vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float({border="rounded", focus=false})]]

vim.cmd [[command! -nargs=0 RestMode execute 'edit restmode' | set filetype=http buftype=nofile]]
