# Set custom session name. Default is based on filename.
# session_name "Example Session"

# Set a custom session root. Default is `$HOME`.
# session_root "~/Projects/example"

# Create session if it does not already exist.
if initialize_session; then

  # Load window layouts if session was created.
  # load_window "example"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
