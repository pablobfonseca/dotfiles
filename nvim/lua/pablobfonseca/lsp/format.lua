-- Uses external CLIs if found on PATH. Prefers LSP formatting when available
-- if you want; keep `prefer_lsp = false` to always use CLIs.

local M = {}

-- 1) Register CLI formatters by name
M.registry = {
  stylua = {
    cmd = "stylua",
    args = function(fname)
      return { "-", "--stdin-filepath", fname }
    end,
    use_stdin = true,
  },
  prettierd = {
    cmd = "prettierd",
    args = function(fname)
      return { fname }
    end, -- prettierd reads the file path
    -- For prettierd we do NOT use stdin; we’ll write file if needed.
    use_stdin = false,
    writes_file = true,
  },
  prettier = {
    cmd = "prettier",
    args = function(fname)
      return { "--stdin-filepath", fname }
    end,
    use_stdin = true,
  },
  deno_fmt = {
    cmd = "deno",
    args = function(fname)
      return { "fmt", "--stdin-filepath", fname, "-" }
    end,
    use_stdin = true,
  },
  gofmt = {
    cmd = "gofmt",
    args = function(_fname)
      return {}
    end,
    use_stdin = true,
  },
  goimports = {
    cmd = "goimports",
    args = function(_fname)
      return {}
    end,
    use_stdin = true,
  },
  black = {
    cmd = "black",
    args = function(fname)
      return { "-q", "-", "--stdin-filename", fname }
    end,
    use_stdin = true,
  },
  shfmt = {
    cmd = "shfmt",
    args = function(fname)
      return { "-filename", fname }
    end,
    use_stdin = true,
  },
  rustfmt = {
    cmd = "rustfmt",
    args = function(_fname)
      return { "--emit", "stdout" }
    end,
    use_stdin = true,
  },
}

-- 2) Map filetypes to formatter sequences (first available wins unless you
--    set stop_after_first = false to try multiple sequentially)
M.by_ft = {
  lua = { "stylua" },
  typescript = { "prettierd", "deno_fmt", "prettier", stop_after_first = true },
  typescriptreact = { "prettierd", "deno_fmt", "prettier", stop_after_first = true },
  javascript = { "prettierd", "prettier", stop_after_first = true },
  javascriptreact = { "prettierd", "prettier", stop_after_first = true },
  json = { "prettierd", "prettier", stop_after_first = true },
  yaml = { "prettierd", "prettier", stop_after_first = true },
  markdown = { "prettierd", "prettier", stop_after_first = true },
  go = { "goimports", "gofmt", stop_after_first = true },
  python = { "black" },
  sh = { "shfmt" },
  rust = { "rustfmt" },
}

-- Prefer LSP format if attached/supports? Change to true if you want that.
M.prefer_lsp = false

-- ── helpers ───────────────────────────────────────────────────────────────────
local function buf_abspath(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" then
    return vim.fn.fnamemodify(name, ":p")
  end
  local ft = vim.bo[buf].filetype or "stdin"
  return vim.fn.getcwd() .. "/stdin." .. ft
end

local function readbuf(buf)
  return table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, true), "\n")
end

local function replacebuf(buf, text)
  local view = vim.fn.winsaveview()
  local lines = vim.split(text, "\n", { plain = true })
  -- Normalize ending newline similar to most formatters
  if lines[#lines] == "" then
    table.remove(lines, #lines)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  vim.fn.winrestview(view)
end

local function lsp_supports_format(buf)
  for _, c in ipairs(vim.lsp.get_clients { bufnr = buf }) do
    if c.server_capabilities and c.server_capabilities.documentFormattingProvider then
      return true
    end
  end
  return false
end

local function format_via_lsp(buf)
  vim.lsp.buf.format { async = false, bufnr = buf }
  return true
end

local function is_exe(cmd)
  return vim.fn.executable(cmd) == 1
end

local function run_cli(spec, buf)
  local fname = buf_abspath(buf)
  local args = spec.args(fname)
  local input = spec.use_stdin and readbuf(buf) or nil

  local res = vim.system({ spec.cmd, unpack(args) }, { text = true, stdin = input }):wait()
  if res.code ~= 0 then
    return false, (res.stderr or ("exit " .. tostring(res.code)))
  end

  if spec.use_stdin then
    if not res.stdout or res.stdout == "" then
      return false, "formatter returned empty output"
    end
    replacebuf(buf, res.stdout)
    return true
  end

  -- Formatter writes file directly (e.g., prettierd): just check for changes.
  if spec.writes_file then
    vim.cmd "checktime" -- reload if the file was modified on disk
    return true
  end

  return true
end

-- Try a list of formatter names until one succeeds (or run all, if desired)
local function format_via_cli_chain(buf, names)
  if not names or #names == 0 then
    return false, "no CLI formatter configured"
  end

  local stop_after_first = names.stop_after_first
  local last_err = nil

  for _, name in ipairs(names) do
    local spec = M.registry[name]
    if not spec then
      last_err = "unknown formatter: " .. tostring(name)
    elseif not is_exe(spec.cmd) then
      last_err = ("formatter not found on PATH: %s"):format(spec.cmd)
    else
      local ok, err = run_cli(spec, buf)
      if ok then
        if stop_after_first ~= false then
          return true
        end
        -- if chaining multiple, keep going
      else
        last_err = err
      end
    end
  end

  return false, last_err or "no formatter succeeded"
end

-- Public API
function M.format_current_buffer(write_after)
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype

  if M.prefer_lsp and lsp_supports_format(buf) then
    format_via_lsp(buf)
  else
    local chain = M.by_ft[ft]
    if not chain then
      vim.notify("[Format] no formatter configured for filetype: " .. tostring(ft), vim.log.levels.WARN)
      return
    end
    local ok, err = format_via_cli_chain(buf, chain)
    if not ok then
      -- fallback to LSP if available
      if lsp_supports_format(buf) then
        format_via_lsp(buf)
      else
        vim.notify("[Format] " .. (err or "failed"), vim.log.levels.WARN)
        return
      end
    end
  end

  if write_after then
    vim.cmd.write()
  end
end

-- Commands + keymap + (optional) on-save
vim.api.nvim_create_user_command("Format", function()
  M.format_current_buffer(false)
end, {})
vim.api.nvim_create_user_command("FormatWrite", function()
  M.format_current_buffer(true)
end, {})

-- Enable format-on-save for the filetypes you want:
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {
    "*.lua",
    "*.ts",
    "*.tsx",
    "*.js",
    "*.jsx",
    "*.json",
    "*.yaml",
    "*.yml",
    "*.md",
    "*.go",
    "*.py",
    "*.sh",
    "*.rs",
  },
  callback = function()
    M.format_current_buffer(false)
  end,
})
