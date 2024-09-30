return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    exclude = {
      filetypes = {
        "help",
        "terminal",
        "lazy",
        "lspinfo",
        "TelescopePrompt",
        "TelescopeResults",
        "mason",
        "",
      },
    },
  },
}
