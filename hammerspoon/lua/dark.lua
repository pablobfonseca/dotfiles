local u = require("lua.utils")

hs.hotkey.bind(u.hyper, "d", function()
  hs.execute(
    "osascript -e 'tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
  )
end)
