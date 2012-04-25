#
# Layout Helpers
#
# These functions are available exclusively within layout files, and enable
# the layout files to function at all, but also provide useful short-hands to
# otherwise more complex means.
#

# Create a new window.
new_window() {
  if [ ! -z "$1" ]; then
    window="$1"
  fi
  tmux new-window -t "$session:" -n "$window"
}

# Load specified window layout.
load_window() {
  local file="$TMUXIFIER_LAYOUT_PATH/$1.window.sh"
  if [ -f "$file" ]; then
    window="$1"
    source "$file"

    # Reset `$window_root`.
    if [[ "$window_root" != "$session_root" ]]; then
      window_root "$session_root"
    fi
  else
    echo "No such window layout found '$1' in '$TMUXIFIER_LAYOUT_PATH'."
  fi
}

# Load specified session layout.
load_session() {
  local file="$TMUXIFIER_LAYOUT_PATH/$1.session.sh"
  if [ -f "$file" ]; then
    session="$1"
    source "$file"

    # Reset `$session_root`.
    if [[ "$session_root" != "$HOME" ]]; then
      session_root="$HOME"
    fi
  else
    echo "No such session layout found '$1' in '$TMUXIFIER_LAYOUT_PATH'."
  fi
}

# Cusomize session root path. Default is `$HOME`.
session_root() {
  local dir="$(__expand_path $@)"
  if [ -d "$dir" ]; then
    session_root="$dir"
  fi
}

# Customize window root path. Default is `$session_root`.
window_root() {
  local dir="$(__expand_path $@)"
  if [ -d "$dir" ]; then
    cd "$dir"
  fi
}

# Create a new session, returning 0 on success, 1 on failure.
#
# Example usage:
#
#   if initialize_session; then
#     load_window "example"
#   fi
#
initialize_session() {
  if [ ! -z "$1" ]; then
    session="$1"
  fi

  # Ensure tmux server is running for has-session check.
  tmux start-server

  # Check if the named session already exists.
  if ! tmux has-session -t "$session" 2>/dev/null; then
    # Create the new session.
    env TMUX= tmux new-session -d -s "$session"

    # Set default-path for session
    if [ ! -z "$session_root" ] && [ -d "$session_root" ]; then
      cd "$session_root"
      tmux set-option -t "$session" default-path "$session_root" 1>/dev/null
    fi

    # In order to ensure only specified windows are created, we move the
    # default window to position 99, and later remove it with the
    # `finalize_session` function.
    tmux move-window -s "$session:0" -t "$session:99"

    # Ensure correct pane splitting.
    __go_to_session

    # Session created, return ok exit status.
    return 0
  fi
  # Session already existed, return error exit status.
  return 1
}

# Finalize session creation and then switch to it if needed.
#
# When the session is created, it leaves a unused window in position #99, this
# is the default window which was created with the session, but it's also a
# window that was not explicitly created. Hence we kill it.
#
# If the session was created, we've already been switched to it. If it was not
# created, the session already exists, and we'll need to specifically switch
# to it here.
finalize_and_go_to_session() {
  tmux kill-window -t "$session:99" 2>/dev/null || true
  if [[ "$(tmuxifier-current-session)" != "$session" ]]; then
    __go_to_session
  fi
}
