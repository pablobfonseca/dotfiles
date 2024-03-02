-- Norg
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.norg",
  command = "Neorg tangle current-file",
})
