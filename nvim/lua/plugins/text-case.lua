vim.pack.add({ "https://github.com/johmsalas/text-case.nvim" }, { load = true })

require("textcase").setup {}

vim.keymap.set({ "n", "x" }, "ga.", "<cmd>TextCaseOpenTelescope<cr>", { desc = "Telescope Text Case" })

pcall(require("telescope").load_extension "textcase")
