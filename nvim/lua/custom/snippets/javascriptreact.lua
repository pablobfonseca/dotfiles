require("luasnip.session.snippet_collection").clear_snippets "javascriptreact"

local ls = require "luasnip"

ls.filetype_extend("javascriptreact", { "javascript" })

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("javascriptreact", {
  s(
    "comp",
    fmt(
      [[
      export default function {}({}) {{
        return {}
      }}
      ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
})
