return {
  "mg979/vim-visual-multi",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_start",
      callback = function()
        pcall(vim.keymap.del, "i", "<BS>", { buffer = 0 })
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function()
        require("nvim-autopairs").force_attach()
      end,
    })
  end,
  config = function()
    vim.g.VM_maps = {
      ["Visual All"] = "M",
    }
  end,
}
