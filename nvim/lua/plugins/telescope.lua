return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim",     build = "make" },
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    { "jvgrootveld/telescope-zoxide" },
    { "jonarrien/telescope-cmdline.nvim" },
    -- { dir = "~/code/upscope-nvim" },
  },
  config = function()
    require "custom.telescope"
  end,
}
