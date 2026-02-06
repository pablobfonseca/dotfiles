-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- prevent neovim from commenting next line
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = "setlocal formatoptions-=cro",
})

-- Show cursorline only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup,
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup,
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

-- Don't list quickfix buffers
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Return the last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "javascript", "typescript", "json", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    -- Check if this buffer should be preserved
    if vim.b.preserve_on_close then
      return
    end
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    if vim.bo.filetype == "oil" or vim.api.nvim_buf_get_name(0) == "" then
      return
    end

    local dir = vim.fn.expand "<afile>:p:h"
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- LSP Info
vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    print "No LSP clients attached to current buffer"
  else
    for _, client in ipairs(clients) do
      print("LSP: " .. client.name .. " (ID: " .. client.id .. ")")
    end
  end
end, { desc = "Show LSP client info" })

-- Debounced document highlight with performance optimizations
local highlight_timer = nil
local last_highlight_request = 0

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = augroup,
  callback = function(args)
    if vim.bo[args.buf].filetype == "nvim-pack" then
      return
    end

    -- Skip highlight in large files
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if lines > 10000 then
      return
    end

    -- Debounce highlight requests
    local now = vim.loop.now()
    if now - last_highlight_request < 500 then -- 500ms debounce
      return
    end

    local clients = vim.lsp.get_clients { bufnr = args.buf }
    for _, client in ipairs(clients) do
      -- Skip document highlight for TypeScript in large projects
      if client.name == "ts_ls" then
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > 100 * 1024 then -- Skip for files > 100KB
          return
        end
      end

      if client:supports_method("textDocument/documentHighlight", args.buf) then
        last_highlight_request = now
        vim.lsp.buf.document_highlight()
        break -- Only request from one client
      end
    end
  end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = augroup,
  callback = function()
    -- Cancel pending highlight timer if cursor moved
    if highlight_timer then
      vim.loop.timer_stop(highlight_timer)
      highlight_timer = nil
    end
    vim.lsp.buf.clear_references()
  end,
})
