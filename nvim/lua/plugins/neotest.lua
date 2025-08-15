return {
  "nvim-neotest/neotest",
  -- enabled = false,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-vim-test",
    "vim-test/vim-test",
    { "pablobfonseca/neotest-go", branch = "fix-deprecations" },
    "nvim-neotest/neotest-python",
  },
  config = function()
    require "custom.neotest"
  end,
}
