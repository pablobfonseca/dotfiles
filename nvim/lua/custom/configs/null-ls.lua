local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- python
  b.formatting.autoflake,

  -- ruby
  b.formatting.rubocop,

  -- elm
  b.formatting.elm_format,

  -- go
  b.formatting.gofmt,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(_, bufnr)
  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format { async = false }
    end,
  })
end

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = on_attach,
}
