vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local cmp = require "cmp"

cmp.setup {
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer",  keyword_length = 3 },
    { name = "lazydev", group_index = 0 },
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
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
}

local ls = require "luasnip"
local luasnip_opts = {
  history = false,
  updateevents = "TextChanged,TextChangedI",
}

ls.config.set_config = luasnip_opts

require("luasnip.loaders.from_vscode").lazy_load(luasnip_opts)
require("luasnip.loaders.from_lua").load()

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
  loadfile(ft_path)()
end
