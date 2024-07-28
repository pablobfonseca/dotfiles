local u = require("lua.utils")
local wm = require("window-management")

local hotkey = hs.hotkey.bind

hotkey(u.master, "l", function()
	wm.moveWindowToPosition(wm.screenPositions.right)
end)

hotkey(u.master, "h", function()
	wm.moveWindowToPosition(wm.screenPositions.left)
end)

hotkey(u.master, "j", function()
	wm.moveWindowToPosition(wm.screenPositions.bottom)
end)

hotkey(u.master, "k", function()
	wm.moveWindowToPosition(wm.screenPositions.top)
end)

hotkey(u.master, "o", function()
	wm.windowMaximize(0)
end)

hotkey(u.alt, "l", function()
	hs.window.focusedWindow():moveOneScreenEast()
end)

hotkey(u.alt, "h", function()
	hs.window.focusedWindow():moveOneScreenWest()
end)

--- Focus the app
--- @param key string key to bind the hotkey
--- @param appName string name of the app to be focused
local function focusApp(key, appName)
	return hotkey(u.master, key, function()
		return hs.application.launchOrFocus(appName)
	end)
end

focusApp("b", "Arc")
-- focusApp("t", "Alacritty")
focusApp("t", "WezTerm")
focusApp("s", "Slack")
focusApp("n", "Obsidian")
focusApp("f", "Firefox")
focusApp("p", "Preview")
focusApp("e", "Emacs")
