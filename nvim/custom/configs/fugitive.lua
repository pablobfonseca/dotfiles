local git_stuff_group = vim.api.nvim_create_augroup("GitStuff", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "gitcommit",
  group = git_stuff_group,
  command = "setl spell",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  group = git_stuff_group,
  command = "setl diffopt+=vertical",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  group = git_stuff_group,
  command = "nmap <buffer> <S-Tab> <C-p>",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/.git/COMMIT_EDITMSG",
  group = git_stuff_group,
  command = "wincmd _",
})
vim.api.nvim_create_autocmd({ "BufEnter"}, {
  pattern = "PULLREQ_EDITMSG",
  command = "setlocal filetype=gitcommit"
})
