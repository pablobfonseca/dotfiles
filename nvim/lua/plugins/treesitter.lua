vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { load = true })

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "css",
    "dockerfile",
    "elm",
    "gitcommit",
    "go",
    "haskell",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "ocaml",
    "python",
    "ruby",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  endwise = {
    enable = true,
  },
  sync_install = false,
  auto_install = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      -- init_selection = "gnn", -- set to `false` to disable one of the mappings
      -- node_incremental = "grn",
      -- scope_incremental = "grc",
      -- node_decremental = "grm",
    },
  },
}

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
      vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfiully", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping...", vim.log.levels.WARN)
      end
    end
  end,
})
