#### COLOUR

tm_icon="ולבפ"
tm_color_active=white
tm_color_inactive=colour241
tm_color_feature=colour10
tm_color_music=colour10
tm_active_border_color=colour10
tm_color_bg=colour235

# separators
tm_separator_left_bold="◀"
tm_separator_left_thin="❮"
tm_separator_right_bold="▶"
tm_separator_right_thin="❯"

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# center the status bar
set -g status-justify left

# default statusbar colors
# set-option -g status-bg colour0
set-option -g status-style fg=white,bg=$tm_color_bg,default
# set-option -g status-fg white
# set-option -g status-bg $tm_color_bg
# set-option -g status-attr default

# default window title colors
# set-window-option -g window-status-fg $tm_color_inactive
# set-window-option -g window-status-bg default
set-window-option -g window-status-style fg=$tm_color_inactive,bg=default
set -g window-status-format "#I #W"

# active window title colors
# set-window-option -g window-status-current-fg $tm_color_active
# set-window-option -g window-status-current-bg default
# set-window-option -g  window-status-current-format "#[bold]#I #W"

# pane border
set-option -g pane-border-style fg=colour235,bg=black
set -g pane-active-border-style fg=$tm_active_border_color,bg=black

# message text
set-option -g message-style fg=$tm_color_active,bg=default

# pane number display
set-option -g display-panes-active-colour $tm_color_active
set-option -g display-panes-colour $tm_color_inactive

# clock
set-window-option -g clock-mode-colour $tm_color_active

tm_itunes="#[fg=$tm_color_music]#(osascript ~/.tmux/applescripts/itunes.scpt)"

tm_date="#[fg=$tm_color_inactive] %a, %b, %d"
tm_hour="#[fg=$tm_color_inactive] %I:%M"
tm_session_name="#[fg=white]$tm_icon #S"

set -g status-left $tm_session_name' '
set -g status-right "Battery: #{battery_icon} #{battery_percentage} #{battery_remain}"' '$tm_date' '$tm_hour
