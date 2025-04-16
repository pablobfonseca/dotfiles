local mc = require "multicursor-nvim"

mc.setup()

-- add cursors above/below the main cursor
-- vim.keymap.set({ "n", "v" }, "<M-k>", function()
--   mc.addCursor "k"
-- end)
-- vim.keymap.set({ "n", "v" }, "<M-j>", function()
--   mc.addCursor "j"
-- end)

-- add a cursor and jump to the next word under cursor
vim.keymap.set({ "n", "v" }, "<C-n>", function()
  mc.addCursor "*"
end)

-- jump to the next word under cursor but do not add a cursor
vim.keymap.set({ "n", "v" }, "q", function()
  if mc.hasCursors() then
    mc.skipCursor "*"
  else
    -- default q handler
  end
end)

-- rotate the main cursor
vim.keymap.set({ "n", "v" }, "]", function()
  if mc.hasCursors() then
    mc.nextCursor()
  else
    -- default ] handler
  end
end)

vim.keymap.set({ "n", "v" }, "[", function()
  if mc.hasCursors() then
    mc.prevCursor()
  else
    -- default [ handler
  end
end)

vim.keymap.set("n", "<esc>", function()
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  elseif mc.hasCursors() then
    mc.clearCursors()
  else
    -- default <esc> handler
  end
end)

vim.keymap.set("v", "M", mc.matchCursors)

vim.keymap.set("n", "<leader>a", mc.alignCursors)
