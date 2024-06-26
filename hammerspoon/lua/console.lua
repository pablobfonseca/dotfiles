local M = {} -- persist from garbage collector

local u = require("lua.utils")

local cons = hs.console
local wf = hs.window.filter

-- CONFIG
-- CONSOLE APPEARANCE

local baseFont = { name = "SauceCodePro Nerd Font", size = 22 }
local darkRed = { red = 0.7, green = 0, blue = 0, alpha = 1 }
local lightRed = { red = 1, green = 0, blue = 0, alpha = 1 }
local darkYellow = { red = 0.7, green = 0.5, blue = 0, alpha = 1 }
local lightYellow = { red = 1, green = 1, blue = 0, alpha = 1 }
local white = { white = 0.9 }
local black = { white = 0.1 }
local darkGrey = { white = 0.45 }
local lightGrey = { white = 0.55 }

-- CONSOLE SETTINGS
cons.titleVisibility("hidden")
cons.toolbar(nil)
cons.consoleFont(baseFont)
hs.consoleOnTop(false)

I = hs.inspect

--- filter console entries, removing logging for enabling/disabling hotkeys
--- useless layout info or warnings or info on extension loading
-- HACK to fix https://www.reddit.com/r/hammerspoon/comments/11ao9ui/how_to_suppress_logging_for_hshotkeyenable/
local function cleanupConsole()
  local consoleOutput = tostring(cons.getConsole())
  cons.clearConsole()
  local consoleLines = hs.fnutils.split(consoleOutput, "\n+")
  if not consoleLines then
    return
  end

  -- remove some lines
  local cleanLines = {}
  for _, line in ipairs(consoleLines) do
    local ignore = line:find("Loading extensions:? ")
        or line:find("Lazy extension loading enabled$")
        or line:find("Loading /Users/pablobfonseca/.config//?hammerspoon/init.lua$")
        or line:find("hs%.canvas:delete")
        or line:find("%-%- Done%.$")
        or line:find("wfilter: .* is STILL not registered") -- FIX https://github.com/Hammerspoon/hammerspoon/issues/3462

    if not ignore then
      table.insert(cleanLines, line)
    end
  end

  -- colorize certain messages
  local isDark = u.isDarkMode()
  for _, line in pairs(cleanLines) do
    local color
    if line:find("^>") then -- user input
      color = isDark and lightGrey or darkGrey
    elseif line:lower():find("error") or line:lower():find("fatal") then
      color = isDark and lightRed or darkRed
    elseif
        line:lower():find("warning")
        or line:find("stack traceback")
        or line:find("fail")
        or line:lower():find("abort")
    then
      color = isDark and lightYellow or darkYellow
    else
      color = isDark and white or black
    end
    local coloredLine = hs.styledtext.new(line, { color = color, font = baseFont })
    cons.printStyledtext(coloredLine)
  end
end

M.wf_hsConsole = wf.new("Hammerspoon"):subscribe(wf.windowFocused, function(win)
  if win:title() == "Hammerspoon Console" then
    u.runWithDelays({ 0, 0.5 }, cleanupConsole)
  end
end)

-- app-hotkeys
u.appHotkey("Hammerspoon", "cmd", "q", hs.closeConsole) -- prevent accidental quitting
u.appHotkey("Hammerspoon", "cmd", "k", hs.console.clearConsole)
u.appHotkey("Hammerspoon", { "cmd", "shift" }, "c", function()
  local consoleHistory = cons.getHistory()
  if not consoleHistory then
    return
  end
  local lastcommand = consoleHistory[#consoleHistory]
  hs.pasteboard.setContents(lastcommand)
  u.notify(('Copied: "%s'):format(lastcommand))
end)

---@param toMode "dark"|"light"
function M.setConsoleColors(toMode)
  if toMode == "dark" then
    cons.darkMode(true)
    cons.outputBackgroundColor(black)
    cons.consolePrintColor(white)
    cons.consoleCommandColor(lightGrey)
  else
    cons.darkMode(false)
    cons.outputBackgroundColor(white)
    cons.consolePrintColor(black)
    cons.consoleCommandColor(darkGrey)
  end
end

-- initialize
if u.isSystemStart() then
  M.setConsoleColors(u.isDarkMode() and "dark" or "light")
end

return M
