vim.pack.add({ "https://github.com/projekt0n/github-nvim-theme" }, { load = true})

require("github-theme").setup {}
vim.cmd.colorscheme "github_dark"
