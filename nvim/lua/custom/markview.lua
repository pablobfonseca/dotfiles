require("markview").setup {
  modes = { "n" },
  hybrid_modes = { "n" },
  callbacks = {
    on_enable = function(_, win)
      vim.wo[win].conceallevel = 2
      vim.wo[win].concealcursor = "c"
    end,
  },
}
