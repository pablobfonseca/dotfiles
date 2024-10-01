#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Close notifications
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🔔

# Documentation:
# @raycast.author pablobfonseca
# @raycast.authorURL https://raycast.com/pablobfonseca

property closeActionSet: {"Close", "Clear All"}

-- Function to perform close action on a given element
on closeNotification(elemRef)
  tell application "System Events"
    try
      set theActions to actions of elemRef
      repeat with act in theActions
        if description of act is in closeActionSet then
          perform act
          return true
        end if
      end repeat
    end try
  end tell
  return false
end closeNotification

-- Function to recursively search for and close notifications
on searchAndCloseNotifications(elemRef)
  tell application "System Events"
    try
      set subElements to UI elements of elemRef
      repeat with subElem in subElements
        if my searchAndCloseNotifications(subElem) then
          return true
        end if
      end repeat
    end try

    -- try to close the current element if it's notification
    if my closeNotification(elemRef) then
      return true
    end if
  end tell
end searchAndCloseNotifications


-- main script to clear notifications
on run
  tell application "System Events"
    if not (exists process "NotificationCenter") then
      log "NotificationCenter process not found"
      return
    end if

    tell process "NotificationCenter"
      if not (exists window "Notification Center") then
        log "NotificationCenter window not found"
        return
      end if

      set notificationWindow to window "Notification Center"

      -- main loop to clear notifications
      repeat
        try
          if not my searchAndCloseNotifications(notificationWindow) then
            -- if no notifications were close, we're done
            exit repeat
          end if

          -- reduced delay to speed up the script
          delay 0.1
        on error errMsg
          -- if an error occurs log it and exit the loop
          log "Error: " & errMsg
          exit repeat
        end try
      end repeat
    end tell
  end tell
end run

# Error: System Events got an error: No result was returned from some part of this expression.
