-- Typescript
--- Organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.ts",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.cmd "OrganizeImports"
    if vim.api.nvim_buf_get_option(bufnr, "modified") then
      vim.cmd "write"
    end
  end,
})

-- Norg
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.norg",
  command = "Neorg tangle current-file",
})
