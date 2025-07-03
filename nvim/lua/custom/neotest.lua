require("neotest").setup {
  adapters = {
    require "neotest-python",
    require "neotest-go",
    require "neotest-vim-test" { ignore_filetypes = { "python", "go", "ruby" } },
  },
}

vim.keymap.set("n", "<leader>Tn", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>Tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run current test file" })

vim.keymap.set("n", "<leader>Td", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "Run current test file (debug)" })

vim.keymap.set("n", "<leader>To", function()
  require("neotest").output.open { enter = true }
end, { desc = "Test output" })
