return {
  "epwalsh/obsidian.nvim",
  cmd = { "ObsidianOpen", "ObsidianNew", "ObsidianTags", "ObsidianQuickSearch", "ObsidianSearch" },
  lazy = false,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require "custom.obsidian"
  end,
}
