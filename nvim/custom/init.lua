-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

require "custom.globals"
require "custom.configs.markdown-text"
require "custom.functions"
require "custom.commands"

vim.g.mapleader = ","
vim.o.relativenumber = true
vim.o.completeopt = "menuone,noselect"

-- prevent neovim from commenting next line
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})

-- remove inline diagnostics
vim.diagnostic.config {
  virtual_text = false,
}
