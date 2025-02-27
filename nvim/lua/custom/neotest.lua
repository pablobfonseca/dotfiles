require("neotest").setup {
  adapters = {
    require "neotest-rspec" {
      rspec_cmd = function()
        return vim
          .iter({
            "upscope",
            "test",
            "app",
            "-t",
          })
          :flatten()
          :totable()
      end,
      transform_spec_path = function(path)
        local prefix = require("neotest-rspec").root(path)
        return string.sub(path, string.len(prefix) + 2, -1)
      end,
    },
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

vim.keymap.set("n", "<leader>To", function()
  require("neotest").output.open { enter = true }
end, { desc = "Test output" })
