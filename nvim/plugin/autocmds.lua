local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Highlight when yanking (copying) text
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- prevent neovim from commenting next line
autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})

-- create directories when needed, when saving a file
--autocmd("BufWritePre", {
--  group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
--  callback = function(event)
--    local file = vim.loop.fs_realpath(event.match) or event.match
--    local backup = vim.fn.fnamemodify(file, ":p:~:h")
--    backup = backup:gsub("[/\\]", "%%")
--    vim.go.backupext = backup
--  end,
--})

-- show cursor line only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})

autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})
