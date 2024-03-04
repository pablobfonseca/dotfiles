return {
  "echasnovski/mini.nvim",
  config = function()
    -- Better Around/inside textobjects
    --
    -- Examples:
    -- - va)  - [V]isually select [A]round [)]paren
    -- - yinq - [Y]ank [I]nside [N]ext [Q]uote
    -- - ci'  - [C]hange [I]nside [']quote
    require("mini.ai").setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc..)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord with [)]paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)]paren with [']quote
    require("mini.surround").setup()
  end,
}
