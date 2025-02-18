return {
  "nvim-neotest/neotest",
  -- enabled = false,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-vim-test",
    "vim-test/vim-test",
    { "pablobfonseca/neotest-go", branch = "fix-deprecations" },
    "nvim-neotest/neotest-python",
    "olimorris/neotest-rspec",
  },
  config = function()
    require "custom.neotest"
  end,
}
