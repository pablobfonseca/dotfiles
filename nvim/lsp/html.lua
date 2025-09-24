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
}
