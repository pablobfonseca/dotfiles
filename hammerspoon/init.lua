G = {} -- persist from garbage collector

-- Try to require the module, and do not error when one of them cannot be
-- loaded, but do notify if there was an error.
-- @param module string module tc local
local function safeRequire(module)
  local success, M = pcall(require, module)
  G[module:sub(5)] = M -- protect timers from garbage collector
  if not success then
    hs.alert("⚠️  Error loading " .. module)
  end
end

-- hammerspoon settings
hs.autoLaunch(true)
hs.menuIcon()
hs.allowAppleScript(true)       -- allow external control (for control via nvim)
hs.automaticallyCheckForUpdates(true)
hs.window.animationDuration = 0 -- quicker animations

safeRequire("lua.console")
safeRequire("lua.window")
safeRequire("lua.reload")
