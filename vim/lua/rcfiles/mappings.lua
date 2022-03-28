-- Mappings config

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('c', '<C-k>', '<up>')
map('c', '<C-j>', '<down>')

map('c', '<C-x><C-e>', '<C-e><C-f>')

