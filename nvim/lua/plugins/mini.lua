return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    -- Better Around/inside textobjects
    --
    -- Examples:
    -- - va)  - [V]isually select [A]round [)]paren
    -- - yinq - [Y]ank [I]nside [N]ext [Q]uote
    -- - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup { n_lines = 500 }
  end,
}
