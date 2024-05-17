require("luasnip.session.snippet_collection").clear_snippets "typescriptreact"

local ls = require "luasnip"

ls.filetype_extend("typescriptreact", { "javascript" })

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescriptreact", {
  s(
    "propt",
    fmt(
      [[
      type Props = {{
        {}
      }}
      ]],
      {
        i(0),
      }
    )
  ),
}, {
  s(
    "comp",
    fmt(
      [[
        export default function {}({}) {{
          return (
          {}
          )
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
