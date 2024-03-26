vim.cmd [[command! -nargs=0 RestMode execute 'edit restmode.http' | set buftype=nofile]]

-- create a command to copy the entire file content
vim.cmd [[command! -nargs=0 CopyFile execute 'normal! ggVGy']]
