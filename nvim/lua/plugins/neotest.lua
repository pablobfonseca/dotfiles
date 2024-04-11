return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        require "neotest-vim-test" (),
      },
    },
  },
  {
    "nvim-neotest/neotest-vim-test",
    dependencies = { "vim-test/vim-test" },
  },
}
