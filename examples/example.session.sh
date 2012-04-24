# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Documents"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "Example Session"; then

  # Example of loading an existing window layout.
  load_window "example"

  # Example of in-line window definition
  new_window "In-line Window"
  tmux split-window -t "$session:$window.0" -v -p 50

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
