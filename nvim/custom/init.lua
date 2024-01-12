local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

require "custom.globals"
require "custom.configs.markdown-text"
require "custom.functions"
require "custom.commands"
require "custom.dev.languages"

vim.g.mapleader = ","
vim.o.relativenumber = true
vim.o.completeopt = "menuone,noselect"

vim.o.foldenable = true
vim.o.foldmethod = "manual"

-- prevent neovim from commenting next line
autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})
