return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  opts_extend = {
    "sources.default",
  },
  version = "*",
  opts = {
    keymap = {
      preset = "default",
      cmdline = {
        preset = "super-tab",
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = {
          border = "single",
          scrollbar = false,
        },
      },
      menu = {
        scrollbar = false,
        border = "single",
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos
            return { pos[1] - 1, pos[2] }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,
      },
      list = {
        selection = function(ctx)
          return ctx.mode == "cmdline" and "auto_insert" or "preselect"
        end,
      },
    },
    sources = {
      default = { "lsp", "path", "luasnip", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 5,
          max_items = 5,
        },
      },
    },
    signature = { enabled = true, window = { border = "single", scrollbar = false } },
  },
}
