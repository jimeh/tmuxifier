# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/Documents"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "Session Name"; then

  # Create a new window inline within session layout definition.
  new_window "window 1"
  run_cmd "pwd"
  split_h 50
  new_window "window 2"
  run_cmd "top"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
