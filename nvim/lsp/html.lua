---@type vim.lsp.Config
return {
  name = "html",
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  settings = {
    html = {
      hover = { documentation = true, references = true },
      suggest = { html5 = true },
      validate = { scripts = true, styles = true },
    },
  },
  init_options = {
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { "html", "css", "javascript" },
  },
}
