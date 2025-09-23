return {
  name = "lua_ls",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers =  { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
      hint = { enable = true },
      completion = { callSnippet = "Both" },
      format = { enable = false },
    },
  }
}
