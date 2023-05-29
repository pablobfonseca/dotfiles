local M = {}

M.configSearch = function()
  local telescope = require "telescope.builtin"

  local opts = {
    prompt_title = "Search inside nvim config",
    cwd = "~/.config/nvim",
  }

  telescope.live_grep(opts)
end

return M
