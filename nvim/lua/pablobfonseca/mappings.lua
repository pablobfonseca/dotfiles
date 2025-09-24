-- Normal screen mapping
local set = vim.keymap.set

-- source file
set({ "n", "v" }, "<space>x", "<cmd>.lua<cr>", { desc = "Execute the current line" })
set("n", "<space><space>x", "<cmd>source %<cr>", { desc = "Execute the current file" })

set("n", "n", "nzzzv", { desc = "Next search result (centered) " })
set("n", "N", "Nzzzv", { desc = "Previous search result (centered) " })
set("n", "<C-d>", "<C-d>zzzv", { desc = "Half page down (centered) " })
set("n", "<C-u>", "<C-u>zzzv", { desc = "Half page up (centered) " })

-- Delete without yanking
set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Buffer navigation
set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

set("n", "gp", "`[v`]", { desc = "Select last paste in visual mode" })

-- Better window navigation
-- set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
-- set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
-- set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
-- set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Split & Resizing
set("n", "<leader>sv", ":vsplit<cr>", { desc = "Split window vertically" })
set("n", "<leader>sh", ":split<cr>", { desc = "Split window horizontally" })
set("n", "<C-Up>", ":resize +2<cr>", { desc = "Increase window height" })
set("n", "<C-Down>", ":resize -2<cr>", { desc = "Decrease window height" })
set("n", "<C-Left>", ":vertical resize -2<cr>", { desc = "Decrease window width" })
set("n", "<C-Right>", ":vertical resize +2<cr>", { desc = "Increase window width" })
set("n", "<leader>gh", "<C-w>t<C-w>K", { desc = "Change vertically split to horizontally" })
set("n", "<leader>gv", "<C-w>t<C-w>H", { desc = "Change horizontally split to vertically" })

-- Move lines up/down
-- set("n", "<M-j>", ":m .+1<cr>==", { desc = "Move lines down" })
-- set("n", "<M-k>", ":m .-2<cr>==", { desc = "Move lines up" })
-- set("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
-- set("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- Better indenting in visual mode
set("v", "<", "<gv", { desc = "Indent left and reselect" })
set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
set("n", "<leader>e", ":Explore<cr>", { desc = "Open file explorer" })

-- Better J behavior
set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Quick config editing
set("n", "<leader>rc", ":e $MYVIMRC<cr>", { desc = "Edit config", silent = true })

-- Copy full path
set("n", "<leader>cp", function()
  local rel = vim.fn.expand "%:." -- path relative to cwd (pwd)
  if rel == "" then
    vim.notify("No file name for this buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", rel) -- use "*" if you prefer primary selection
  vim.notify("copied: " .. rel)
end, { desc = "Copy relative file path" })

set("n", "z=", function()
  local suggestions = vim.fn.spellsuggest(vim.fn.expand "<cword>", 20)
  if #suggestions == 0 then
    vim.cmd "normal! z="
    return
  end

  vim.ui.select(suggestions, {
    prompt = "Spelling suggestions",
  }, function(choice)
    if choice then
      vim.cmd("normal! ciw" .. choice)
    end
  end)
end, { desc = "Spell suggestions" })
