local set = vim.keymap.set

-- source file
set({ "n", "v" }, "<space>x", "<cmd>.lua<cr>", { desc = "Execute the current line" })
set("n", "<space><space>x", "<cmd>source %<cr>", { desc = "Execute the current file" })

-- emacs-like keybindings
-- set("n", "<C-x><C-s>", ":w<cr>", { desc = "Save the file" })
-- set("n", "<C-x>1", ":only<cr>", { desc = "Keep only the current pane" })
-- set("n", "<C-x>2", ":split<cr>", { desc = "Split pane horizontally" })
-- set("n", "<C-x>3", ":vsplit<cr>", { desc = "Split pane vertically" })
-- set("n", "<C-x>0", ":q<cr>", { desc = "Close pane" })

set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", "J", "mzJ`z", { desc = "Join lines but keep cursor position" })

set("x", "<leader>p", [["_dP]], { desc = "Paste without losing the current register" })

-- navigate within insert mode
set("i", "<C-h>", "<Left>")
set("i", "<C-l>", "<Right>")
set("i", "<C-j>", "<Down>")
set("i", "<C-k>", "<Up>")

-- navigate the quickfix list
set("n", "<leader>cn", ":cnext<cr>")
set("n", "<leader>cb", ":cprevious<cr>")
set("n", "<leader><space>", ":ccl<cr>", { desc = "Close quickfix window" })

set("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
set("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

set("n", "gp", "`[v`]", { desc = "Select last paste in visual mode" })

set("n", "<leader>gh", "<C-w>t<C-w>K", { desc = "Change vertically split to horizontally" })
set("n", "<leader>gv", "<C-w>t<C-w>H", { desc = "Change horizontally split to vertically" })

set({ "n", "v" }, "<C-e>", "7<C-e>", { desc = "Scroll the viewport faster" })
set({ "n", "v" }, "<C-y>", "7<C-y>", { desc = "Scroll the viewport faster" })

-- exit terminal mode
set("t", "<Esc><Esc>", "<C-\\><C-m>", { desc = "Exit terminal mode" })

-- insert a line above the cursor without leaving normal mode
set("n", "gO", "mmO<esc>`m", { desc = "Insert a new line above the cursor without leaving normal mode" })
set("n", "go", "mmo<esc>`m", { desc = "Insert a new line below the cursor without leaving normal mode" })

-- increment number
set("n", "<M-a>", "<C-a>")
set("n", "<M-x>", "<C-x>")

-- zoom current window
set("n", "<C-w>z", "<C-w>|<C-w>_")
