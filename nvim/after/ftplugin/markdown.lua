local setlocal = vim.opt_local

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    setlocal.wrap = true
    setlocal.conceallevel = 1
  end,
})
