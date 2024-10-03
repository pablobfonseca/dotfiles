require("octo").setup {
  users = "mentionable",
  enable_builtin = true,
  suppress_missing_scope = {
    projects_v2 = true,
  },
}

local set = vim.keymap.set

set("n", "<C-c>ors", "<cmd>Octo review start<cr>", { desc = "[O]cto [R]eview [S]tart" })
set("n", "<C-c>orr", "<cmd>Octo review resume<cr>", { desc = "[O]cto [R]eview [R]esume" })
set("n", "<C-c>orS", "<cmd>Octo review submit<cr>", { desc = "[O]cto [R]eview [S]ubmit" })
set("n", "<C-c>opm", function()
  require("octo.commands").merge_pr "commit"
  vim.notify("PR Merged", vim.log.levels.INFO)
end, { desc = "[O]cto [P]R [M]erge" })
set("n", "<C-c>opl", "<cmd>Octo pr list<cr>", { desc = "[O]cto [P]R [L]ist" })
set("n", "<C-c>opc", "<cmd>Octo pr create<cr>", { desc = "[O]cto [P]R [C]reate" })
set("n", "<C-c>oil", "<cmd>Octo issue list assignee=pablobfonseca<cr>", { desc = "[O]cto My [I]ssue [L]ist" })
set("n", "<C-c>oiL", "<cmd>Octo issue list<cr>", { desc = "[O]cto [I]ssue [L]ist" })
set("n", "<C-c>oic", "<cmd>Octo issue create<cr>", { desc = "[O]cto [I]ssue [C]reate" })
