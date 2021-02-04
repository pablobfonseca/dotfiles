local hyper = {'ctrl', 'alt', 'cmd'}
local master = {'ctrl', 'cmd'}

hs.hotkey.bind(hyper, 'r', function()
  hs.reload()
end)
hs.alert.show('Config loaded!')

hs.loadSpoon('MiroWindowsManager')

hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
  up = {master, 'k'},
  right = {master, 'l'},
  down = {master, 'j'},
  left = {master, 'h'},
  fullscreen = {master, 'o'}
})

function focusApp(key, appName)
   return hs.hotkey.bind(master, key, function()
     return hs.application.launchOrFocus(appName)
   end)
end

focusApp('b', 'Google Chrome')
focusApp('e', 'Emacs')
focusApp('t', 'iTerm')
focusApp('f', 'Finder')
focusApp('s', 'Slack')
focusApp('v', 'Stremio')
focusApp('i', 'Linear')
