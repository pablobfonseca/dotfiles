-- create a command to copy the entire file content
vim.cmd [[command! -nargs=0 CopyFile execute 'normal! ggVGy']]
