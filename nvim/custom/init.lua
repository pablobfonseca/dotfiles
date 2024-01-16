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

local arrow_keys = { "<up>", "<left>", "<down>", "<right>" }
for _, key in ipairs(arrow_keys) do
  vim.api.nvim_set_keymap("n", key, "<cmd>echo 'Use hjkl Brav!'<cr>", { noremap = true, silent = true })
end

-- prevent neovim from commenting next line
autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})
