# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/Desktop"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "Example Window"

# Split window into panes.
tmux split-window -t "$session:$window.0" -v -p 20 "watch -t date"
tmux split-window -t "$session:$window.1" -h -p 60

# Set active pane.
tmux select-pane -t "$session:$window.0"
