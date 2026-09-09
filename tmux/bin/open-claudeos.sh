#!/usr/bin/env bash
set -euo pipefail

window_id=$(tmux list-windows -f '#{==:#{@claudeos_window},1}' -F '#{window_id}' | head -n1)

if [ -n "$window_id" ]; then
  tmux select-window -t "$window_id"
else
  window_id=$(tmux new-window -P -F '#{window_id}' -n claudeos claudeos)
  tmux set-option -w -t "$window_id" @claudeos_window 1
fi
