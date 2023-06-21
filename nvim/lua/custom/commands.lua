-- Open diagnostics in a floating window
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float({border="rounded", focus=false})]]

-- creates a command that looks for a buffer called restmode, if it does not exists, create a new buffer setting the filetype to http and name the buffer restmode
vim.cmd [[command! -nargs=0 RestMode execute 'edit restmode' | set filetype=http]]
