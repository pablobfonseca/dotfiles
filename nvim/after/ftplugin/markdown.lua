local setlocal = vim.opt_local

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    setlocal.wrap = true
    setlocal.conceallevel = 2
  end,
})
