return {
  "hrsh7th/nvim-cmp",
  lazy = false,
  dependencies = {
    "onsails/lspkind.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "petertriho/cmp-git",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").load()

        for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
          loadfile(ft_path)()
        end
      end,
    },
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
    vim.opt.shortmess:append "c"

    local cmp = require "cmp"

    cmp.setup {
      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 3 },
        { name = "lazydev", group_index = 0 },
      },
      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-y>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
        scrollbar = false,
      },
      formatting = {
        format = require("lspkind").cmp_format {
          mode = "symbol_text",
          preset = "codicons",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,
        },
      },
      filetype = {
        gitcommit = {
          sources = cmp.config.sources({
            { name = "buffer" },
          }, { name = "buffer" }),
        },
      },
    }

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local ls = require "luasnip"
    local luasnip_opts = {
      history = false,
      updateevents = "TextChanged,TextChangedI",
    }

    ls.config.set_config = luasnip_opts

    require("luasnip.loaders.from_vscode").lazy_load(luasnip_opts)
    require("luasnip.loaders.from_lua").load()
  end,
}
