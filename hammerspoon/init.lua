local wm = require("window-management")

local hyper = { "ctrl", "alt", "cmd" }
local master = { "ctrl", "cmd" }
local alt = { "cmd", "alt" }

hs.hotkey.bind(hyper, "r", function()
	hs.reload()
end)
hs.alert.show("Config loaded!")

hs.hotkey.bind(master, "l", function()
	wm.moveWindowToPosition(wm.screenPositions.right)
end)

hs.hotkey.bind(master, "h", function()
	wm.moveWindowToPosition(wm.screenPositions.left)
end)

hs.hotkey.bind(master, "j", function()
	wm.moveWindowToPosition(wm.screenPositions.bottom)
end)

hs.hotkey.bind(master, "k", function()
	wm.moveWindowToPosition(wm.screenPositions.top)
end)

hs.hotkey.bind(master, "o", function()
	wm.windowMaximize(0)
end)

function focusApp(key, appName)
	return hs.hotkey.bind(master, key, function()
		return hs.application.launchOrFocus(appName)
	end)
end

hs.hotkey.bind(alt, "l", function()
	hs.window.focusedWindow():moveOneScreenEast()
end)

hs.hotkey.bind(alt, "h", function()
	hs.window.focusedWindow():moveOneScreenWest()
end)

focusApp("b", "Arc")
focusApp("t", "iTerm")
focusApp("w", "Warp")
focusApp("s", "Slack")
focusApp("n", "Obsidian")
