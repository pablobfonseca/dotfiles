return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  opts_extend = {
    "sources.default",
  },
  version = "v0.*",
  opts = {
    keymap = { preset = "default" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
          scrollbar = false,
        },
      },
      menu = {
        scrollbar = false,
        border = "single",
      },
      list = {
        selection = "auto_insert",
      },
    },
    sources = {
      default = { "lsp", "path", "luasnip", "snippets", "buffer", "lazydev" },
      cmdline = {},
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", fallbacks = { "lsp" } },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 3,
        },
      },
    },
    signature = { enabled = true },
  },
}
