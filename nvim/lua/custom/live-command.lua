require("live-command").setup {
  commands = {
    Norm = {
      cmd = "norm",
    },
  },
}
-- Transforms ":5Reg a" into ":norm 5@a"
local function get_command_string(cmd)
  local get_range_string = require("live-command").get_range_string
  local args = (cmd.count == -1 and "" or cmd.count) .. "@" .. cmd.args
  return get_range_string(cmd) .. "norm" .. args
end

vim.api.nvim_create_user_command("Reg", function(cmd)
  vim.cmd(get_command_string(cmd))
end, {
  nargs = "?",
  range = true,
  preview = function(cmd, preview_ns, preview_buf)
    local cmd_to_preview = get_command_string(cmd)
    return require("live-command").preview_callback(cmd_to_preview, preview_ns, preview_buf)
  end,
})
