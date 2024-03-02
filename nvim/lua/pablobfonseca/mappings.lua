vim.g.mapleader = ","

-- emacs-like keybindings
vim.keymap.set("n", "<C-x><C-s>", ":w<cr>", { desc = "Save the file" })
vim.keymap.set("n", "<C-x><C-c>", ":x<cr>", { desc = "Save and quit" })
vim.keymap.set("n", "<C-x>1", ":only<cr>", { desc = "Keep only the current pane" })
vim.keymap.set("n", "<C-x>2", ":split<cr>", { desc = "Split pane horizontally" })
vim.keymap.set("n", "<C-x>3", ":vsplit<cr>", { desc = "Split pane vertically" })
vim.keymap.set("n", "<C-x>0", ":q<cr>", { desc = "Close pane" })

vim.keymap.set("v", "J", ":m '>+0<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines but keep cursor position" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without losing the current register" })

vim.keymap.set("n", ";", ":", { nowait = true, desc = "Enter command mode with ;" })

-- navigate within insert mode
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")

-- go to beginning and end
vim.keymap.set("i", "<C-b>", "<ESC>^i")
vim.keymap.set("i", "<C-e>", "<End>")

-- switch between windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- indent line
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
vim.keymap.set("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
vim.keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

vim.keymap.set("n", "gp", "`[v`]", { desc = "Select last paste in visual mode" })

vim.keymap.set("n", "<leader>fh", "<C-w>t<C-w>K", { desc = "Change vertically split to horizontally" })
vim.keymap.set("n", "<leader>fv", "<C-w>t<C-w>H", { desc = "Change horizontally split to vertically" })

vim.keymap.set("n", "<space><space>", ":ccl<cr>", { desc = "Close quickfix window" })

vim.keymap.set({ "n", "v" }, "<C-e>", "7<C-e>", { desc = "Scroll the viewport faster" })
vim.keymap.set({ "n", "v" }, "<C-y>", "7<C-y>", { desc = "Scroll the viewport faster" })

-- functions mappings
vim.keymap.set("n", "<leader>sr", function()
  require("pablobfonseca.functions").config_search()
end, { desc = "Search for nvim config" })

vim.keymap.set("n", "<leader>rp", function()
  require("pablobfonseca.functions").config_files()
end, { desc = "Find nvim config files" })

vim.keymap.set("n", "<leader>df", function()
  require("pablobfonseca.functions").find_dotfiles()
end, { desc = "Find dotfiles" })
