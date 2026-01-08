---@type vim.lsp.Config
return {
  name = "lua_ls",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".git", "stylua.toml", ".stylua.toml" },
  settings = {
    Lua = {
      codelens = { enable = true },
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
      hint = { enable = true, semicolumn = "Disable" },
      completion = { callSnippet = "Both" },
      format = { enable = false },
    },
  },
}
