return {
  "alexghergh/nvim-tmux-navigation",
  event = "VeryLazy",
  opts = {
    disable_when_zoomed = true,
  },
  config = function(_, opts)
    local nvim_tmux_nav = require "nvim-tmux-navigation"
    nvim_tmux_nav.setup(opts)

    vim.keymap.set("n", "<c-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    vim.keymap.set("n", "<c-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    vim.keymap.set("n", "<c-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    vim.keymap.set("n", "<c-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
  end,
}
