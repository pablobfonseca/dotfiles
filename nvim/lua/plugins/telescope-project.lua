return {
  "nvim-telescope/telescope-project.nvim",
  keys = {
    {
      "<leader>cd",
      mode = "n",
      desc = "Telescope project",
      function()
        require("telescope").extensions.project.project { display_type = "full" }
      end,
    },
  },
  config = function()
    local telescope = require "telescope"
    telescope.setup {
      extensions = {
        project = {
          base_dirs = {
            "~/code",
            { "~/.dotfiles" },
          },
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true,
          on_project_selected = function(prompt_bufnr)
            require("telescope._extensions.project.actions").find_project_files(prompt_bufnr, true)
          end,
        },
      },
    }
    telescope.load_extension "project"
  end,
}
