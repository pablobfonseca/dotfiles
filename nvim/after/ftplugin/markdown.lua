vim.api.nvim_create_autocmd("BufEnter", {
  buffer = 0,
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})
