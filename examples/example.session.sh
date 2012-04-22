# Set custom session name. Default is based on filename.
session_name "Example Session"

# Set a custom session root. Default is `$HOME`.
session_root "~/Documents"

# Create session if it does not already exist.
if initialize_session; then

  # Example of loading an existing window layout.
  load_window "example"

  # Example of in-line window definition
  window_name "In-line Window"
  tmux new-window -t "$session" -n "$window"
  tmux split-window -t "$session:$window.0" -v -p 50

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
