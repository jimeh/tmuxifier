# Set custom window name. Default is based on filename.
window_name "Example Window"

# Set a window root path. Default is `$session_root`.
window_root "~/Desktop"

# Create new window. Remove if you want to apply layout to current window.
tmux new-window -t "$session" -n "$window"

# Split window into panes.
tmux split-window -t "$session:$window.0" -v -p 20 "watch -t date"
tmux split-window -t "$session:$window.1" -h -p 60

# Set active pane.
tmux select-pane -t "$session:$window.0"
