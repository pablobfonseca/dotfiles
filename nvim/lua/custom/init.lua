-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

require "custom.globals"
require "custom.configs.markdown-text"
require "custom.functions"

vim.g.mapleader = ","
vim.o.relativenumber = true
