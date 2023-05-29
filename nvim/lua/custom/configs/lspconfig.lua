local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "solargraph", "pyright", "gopls", "elmls", "rust_analyzer" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

--
-- lspconfig.pyright.setup { blabla}
lspconfig.solargraph.setup {
  init_options = {
    solargraph = {
      formatting = true,
    },
  },
  settings = {
    solargraph = {
      diagnostics = true,
    },
  },
}
