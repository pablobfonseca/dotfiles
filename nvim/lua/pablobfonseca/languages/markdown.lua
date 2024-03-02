local markdown_and_text_group = vim.api.nvim_create_augroup("MarkDownAndText", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  group = markdown_and_text_group,
  command = "setlocal nolist wrap lbr",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md,*.txt",
  group = markdown_and_text_group,
  command = "setlocal spell",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.txt",
  group = markdown_and_text_group,
  command = "setlocal nolist",
})
