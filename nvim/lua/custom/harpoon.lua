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

vim.keymap.set("n", "<C-c>ha", function()
  require("harpoon"):list():add()
end, { desc = "Add file to harpoon" })

vim.keymap.set("n", "<C-c>hh", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Toggle harpoon" })

vim.keymap.set("n", "<C-c>hn", function()
  require("harpoon"):list():next()
end, { desc = "Navigate to next file" })

vim.keymap.set("n", "<C-c>hb", function()
  require("harpoon"):list():prev()
end, { desc = "Navigate to previous file" })
