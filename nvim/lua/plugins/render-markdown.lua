return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = {
    "markdown",
    "octo",
    "Avante",
    "codecompanion",
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "3rd/image.nvim",
      ft = "markdown",
      opts = {
        integrations = {
          markdown = {
            only_render_image_at_cursor = true,
          },
        },
      },
    },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = {
      "markdown",
      "octo",
      "Avante",
      "codecompanion",
    },
    only_render_image_at_cursor = "true",
    completions = {
      lsp = {
        enabled = true,
      },
    },
  },
}
