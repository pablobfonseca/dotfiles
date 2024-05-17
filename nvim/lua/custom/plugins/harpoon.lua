return {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  keys = {
    {
      "<C-c>ha",
      mode = "n",
      desc = "Add file to harpoon",
      function()
        require("harpoon"):list():add()
      end,
    },
    {
      "<C-c>hh",
      mode = "n",
      desc = "Toggle harpoon",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
    },
    {
      "<C-c>hn",
      mode = "n",
      desc = "Navigate to next file",
      function()
        require("harpoon"):list():next()
      end,
    },
    {
      "<C-c>hb",
      mode = "n",
      desc = "Navigate to previous file",
      function()
        require("harpoon"):list():prev()
      end,
    },
  },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup {}

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
    end

    vim.keymap.set("n", "<C-c>hT", function()
      toggle_telescope(harpoon:list())
    end, { desc = "Telescope harpoon" })
  end,
}
