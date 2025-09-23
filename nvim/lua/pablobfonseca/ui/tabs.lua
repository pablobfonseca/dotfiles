-- Transparent tabline appearance
vim.cmd [[
hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE
]]

local set = vim.keymap.set

-- Alternative navigation (more intuitive)
set("n", "<leader>tn", ":tabnew<cr>", { desc = "New tab" })
set("n", "<leader>tx", ":tabclose<cr>", { desc = "Close tab" })

-- Tab moving
set("n", "<leader>tm", ":tabmove<cr>", { desc = "Move tab" })
set("n", "<leader>t>", ":tabmove +1<cr>", { desc = "Move tab right" })
set("n", "<leader>t<", ":tabmove -1<cr>", { desc = "Move tab left" })

-- Function to open file in new tab
local function open_file_in_tab()
  vim.ui.input({ prompt = "File to open in new tab: ", completion = "file" }, function(input)
    if input and input ~= "" then
      vim.cmd("tabnew " .. input)
    end
  end)
end

-- Function to duplicate current tab
local function duplicate_tab()
  local current_file = vim.fn.expand "%:p"
  if current_file ~= "" then
    vim.cmd("tabnew " .. current_file)
  else
    vim.cmd "tabnew"
  end
end

-- Function to close tabs to the right
local function close_tabs_right()
  local current_tab = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr "$"

  for i = last_tab, current_tab + 1, -1 do
    vim.cmd(i .. "tabclose")
  end
end

-- Function to close tabs to the left
local function close_tabs_left()
  local current_tab = vim.fn.tabpagenr()

  for _ = current_tab - 1, 1, -1 do
    vim.cmd "1tabclose"
  end
end

-- Enhanced keybindings
set("n", "<leader>tO", open_file_in_tab, { desc = "Open file in new tab" })
set("n", "<leader>td", duplicate_tab, { desc = "Duplicate current tab" })
set("n", "<leader>tr", close_tabs_right, { desc = "Close tabs to the right" })
set("n", "<leader>tL", close_tabs_left, { desc = "Close tabs to the left" })

-- Function to close buffer but keep tab if it's the only buffer in tab
local function smart_close_buffer()
  local buffers_in_tab = #vim.fn.tabpagebuflist()
  if buffers_in_tab > 1 then
    vim.cmd "bdelete"
  else
    -- If it's the only buffer in tab, close the tab
    vim.cmd "tabclose"
  end
end
set("n", "<leader>bd", smart_close_buffer, { desc = "Smart close buffer/tab" })
