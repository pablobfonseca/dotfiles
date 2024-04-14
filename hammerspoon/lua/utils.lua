local M = {} -- persist from garbage collector

M.hyper = { "ctrl", "alt", "cmd" }
M.master = { "ctrl", "cmd" }
M.alt = { "cmd", "alt" }

--- binds a hotkey for a specific application only
--- @param appName string
--- @param modifier string|string[]
--- @param key string
--- @param action function
function M.appHotkey(appName, modifier, key, action)
  hs.hotkey.bind(modifier, key, function()
    local frontApp = hs.application.frontmostApplication()
    if frontApp:name() == appName then
      action()
    end
    hs.eventtap.keyStroke(modifier, key, 1, frontApp)
  end)
end

--- differentiate code to be run on reload and code to be run on startup.
--- dependent on the seup in `reload.lua`
--- @return boolean
--- @nodiscard
function M.isSystemStart()
  local _, isReloading = hs.execute("test -f /tmp/hs-is-reloading")
  return not isReloading
end

--- Repeat a function multiple times
--- @param delaySecs number|number[]
--- @param callbackFn function function to be run on delay(s)
function M.runWithDelays(delaySecs, callbackFn)
  if type(delaySecs) == "number" then
    delaySecs = { delaySecs }
  end
  for _, delay in pairs(delaySecs) do
    M[hs.host.uuid()] = hs.timer.doAfter(delay, callbackFn):start()
  end
end

---@nodiscard
---@return boolean
function M.isDarkMode()
  return hs.execute("defaults read -g AppleInterfaceStyle") == "Dark\n"
end

---Send system Notification, accepting any number of arguments of any type
---Converts everything into strings, concatenates them, and then sends it
function M.notify(...)
  local args = hs.fnutils.map({ ... }, function(arg)
    local safeArg = (type(arg) == "table" and hs.inspect(arg) or tostring(arg))
    return safeArg
  end)
  if not args then
    return
  end
  local out = table.concat(args, " ")
  hs.notify.show("Hammerspoon", "", out)
  print("💬 " .. out)
end

return M
