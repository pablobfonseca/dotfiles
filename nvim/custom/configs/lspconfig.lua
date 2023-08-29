local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "solargraph",
  "pyright",
  "gopls",
  "elmls",
  "rust_analyzer",
  "tailwindcss",
  "jsonls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.jsonls.setup = {
  filetypes = { "json", "jsonc" },
}

lspconfig.tsserver.setup {
  filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
}

-- lspconfig.jsonls.setup {
--   filetypes = { "json", "jsonc" },
--   settings = {
--     json = {
--       schemas = {
--         {
--           fileMatch = { "package.json" },
--           url = "https://json.schemastore.org/package.json",
--         },
--         {
--           fileMatch = { "tsconfig*.json" },
--           url = "https://json.schemastore.org/tsconfig.json",
--         },
--       },
--     },
--   },
-- }

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
