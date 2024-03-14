vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  command = "setlocal conceallevel=2",
})
