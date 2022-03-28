--[[
        _
 __   _(_)_ __ ___
 \ \ / / | '_ ` _ \
  \ V /| | | | | | |
   \_/ |_|_| |_| |_|
 File: init.lua
 Author: Pablo Fonseca <pablofonseca777@gmail.com>
 Description: NeoVim Rocks!
 Source: http://github.com/pablobfonseca/dotfiles
--]]

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

g.mapleader = ","
g.maplocalleader = "-"

cmd 'filetype off'
cmd 'filetype plugin indent on'

cmd 'autocmd!'
opt.compatible = false

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.smart_enter()
  if fn.pumvisible() == 1 then
    return fn['coc#select_confirm']()
  else
    return t'<C-g>u'
  end
end

cmd 'packadd paq-nvim' -- load package manager
local paq = require('paq-nvim').paq -- a convenient alias

paq {'savq/paq-nvim', opt = true} -- paq-nvim manages itself

map('c', '<C-k>', '<up>')
map('c', '<C-j>', '<down>')

map('c', '<C-x><C-e>', '<C-e><C-f>')
map('c', '%%', '<C-R>=expand("%:h")."/"<cr>')

-- Enable indent folding
opt.foldenable = true
opt.foldmethod = 'indent'
opt.foldlevel = 999

-- Quick fold to level 1
map('n', '<leader>fld', '<cmd>set foldlevel=1<cr>')

-- Maps for folding, unfolding all
map('n', '<leader>fu', 'zM<CR>')
map('n', '<leader>uf', 'zR<CR>')

-- Maps for setting foldlevel

