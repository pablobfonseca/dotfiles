return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  enabled = false,
  keys = {
    {
      "<M-j>",
      mode = "n",
      desc = "Create cursor down",
      "<Plug>(VM-Add-Cursor-Down)",
    },
    {
      "<M-l>",
      mode = "n",
      desc = "Create cursor right",
      "<Plug>(VM-Select-l)",
    },
    {
      "<M-h>",
      mode = "n",
      desc = "Create cursor left",
      "<Plug>(VM-Select-h)",
    },
    {
      "<M-k>",
      mode = "n",
      desc = "Create cursor up",
      "<Plug>(VM-Add-Cursor-Up)",
    },
    {
      "M",
      mode = "v",
      desc = "Select all selected",
      "<Plug>(VM-Select-Al)",
    },
  },
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
