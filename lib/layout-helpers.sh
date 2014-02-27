#
# Layout Helpers
#
# These functions are available exclusively within layout files, and enable
# the layout files to function at all, but also provide useful short-hands to
# otherwise more complex means.
#

# Alias tmux to tmuxifier-tmux wrapper.
tmux() {
  tmuxifier-tmux "$@"
}

# Create a new window.
#
# Arguments:
#   - $1: (optional) Name/title of window.
#   - $2: (optional) Shell command to execute when window is created.
#
new_window() {
  if [ -n "$1" ]; then window="$1"; fi
  if [ -n "$2" ]; then local command=("$2"); fi
  if [ -n "$window" ]; then local winarg=(-n "$window"); fi

  tmuxifier-tmux new-window -t "$session:" "${winarg[@]}" "${command[@]}"
  __go_to_window_or_session_path
}

# Split current window/pane vertically.
#
# Arguments:
#   - $1: (optional) Percentage of frame the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_v() {
  if [ -n "$1" ]; then local percentage=(-p "$1"); fi
  tmuxifier-tmux split-window -t "$session:$window.$2" -v "${percentage[@]}"
  __go_to_window_or_session_path
}

# Split current window/pane horizontally.
#
# Arguments:
#   - $1: (optional) Percentage of frame the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_h() {
  if [ -n "$1" ]; then local percentage=(-p "$1"); fi
  tmuxifier-tmux split-window -t "$session:$window.$2" -h "${percentage[@]}"
  __go_to_window_or_session_path
}

# Split current window/pane vertically by line count.
#
# Arguments:
#   - $1: (optional) Number of lines the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_vl() {
  if [ -n "$1" ]; then local count=(-l "$1"); fi
  tmuxifier-tmux split-window -t "$session:$window.$2" -v "${count[@]}"
  __go_to_window_or_session_path
}

# Split current window/pane horizontally by column count.
#
# Arguments:
#   - $1: (optional) Number of columns the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_hl() {
  if [ -n "$1" ]; then local count=(-l "$1"); fi
  tmuxifier-tmux split-window -t "$session:$window.$2" -h "${count[@]}"
  __go_to_window_or_session_path
}

# Run clock mode.
#
# Arguments:
#   - $1: (optional) Target pane ID in which to run
clock() {
  tmuxifier-tmux clock-mode -t "$session:$window.$1"
}

# Select a specific window.
#
# Arguments:
#   - $1: Window ID or name to select.
#
select_window() {
  tmuxifier-tmux select-window -t "$session:$1"
}

# Select a specific pane in the current window.
#
# Arguments:
#   - $1: Pane ID to select.
#
select_pane() {
  tmuxifier-tmux select-pane -t "$session:$window.$1"
}

# Send/paste keys to the currently active pane/window.
#
# Arguments:
#   - $1: String to paste.
#   - $2: (optional) Target pane ID to send input to.
#
send_keys() {
  tmuxifier-tmux send-keys -t "$session:$window.$2" "$1"
}

# Runs a shell command in the currently active pane/window.
#
# Arguments:
#   - $1: Shell command to run.
#   - $2: (optional) Target pane ID to run command in.
#
run_cmd() {
  send_keys "$1" "$2"
  send_keys "C-m" "$2"
}

# Customize session root path. Default is `$HOME`.
#
# Arguments:
#   - $1: Directory path to use for session root.
#
session_root() {
  local dir="$(__expand_path $@)"
  if [ -d "$dir" ]; then
    session_root="$dir"
  fi
}

# Customize window root path. Default is `$session_root`.
#
# Arguments:
#   - $1: Directory path to use for window root.
#
window_root() {
  local dir="$(__expand_path $@)"
  if [ -d "$dir" ]; then
    window_root="$dir"
  fi
}

# Load specified window layout.
#
# Arguments:
#   - $1: Name of or file path to window layout to load.
#   - $2: (optional) Override default window name.
#
load_window() {
  local file="$1"
  if [ ! -f "$file" ]; then
    file="$TMUXIFIER_LAYOUT_PATH/$1.window.sh"
  fi

  if [ -f "$file" ]; then
    if [ $# -gt 1 ]; then
      window="$2"
    else
      window="${1/%.window.sh}"
      window="${window/%.sh}"
    fi
    source "$file"
    window=

    # Reset `$window_root`.
    if [[ "$window_root" != "$session_root" ]]; then
      window_root "$session_root"
    fi
  else
    echo "\"$1\" window layout not found." >&2
    return 1
  fi
}

# Load specified session layout.
#
# Arguments:
#   - $1: Name of or file path to session layout to load.
#   - $2: (optional) Override default window name.
#
load_session() {
  local file="$1"
  if [ ! -f "$file" ]; then
    file="$TMUXIFIER_LAYOUT_PATH/$1.session.sh"
  fi

  if [ -f "$file" ]; then
    if [ $# -gt 1 ]; then
      session="$2"
    else
      session="${1/%.session.sh}"
      session="${session/%.sh}"
    fi

    set_default_path=true
    source "$file"
    session=

    # Reset `$session_root`.
    if [[ "$session_root" != "$HOME" ]]; then
      session_root="$HOME"
    fi
  else
    echo "\"$1\" session layout not found." >&2
    return 1
  fi
}

# Create a new session, returning 0 on success, 1 on failure.
#
# Arguments:
#   - $1: (optional) Name of session to create, if not specified `$session`
#         is used.
#
# Example usage:
#
#   if initialize_session; then
#     load_window "example"
#   fi
#
initialize_session() {
  if [ -n "$1" ]; then
    session="$1"
  fi

  # Ensure tmux server is running for has-session check.
  tmuxifier-tmux start-server

  # Check if the named session already exists.
  if ! tmuxifier-tmux has-session -t "$session:" 2>/dev/null; then
    if [ "$(tmuxifier-tmux-version "1.9")" == "<" ]; then
      # Tmux 1.8 and earlier.

      # Create the new session.
      env TMUX="" tmuxifier-tmux new-session -d -s "$session"

      # Set default-path for session
      if [ -n "$session_root" ] && [ -d "$session_root" ]; then
        cd "$session_root"

        $set_default_path && tmuxifier-tmux \
          set-option -t "$session:" \
          default-path "$session_root" 1>/dev/null
      fi
    else
      # Tmux 1.9 and later.
      if $set_default_path; then local session_args=(-c "$session_root"); fi
      env TMUX="" tmuxifier-tmux new-session \
        -d -s "$session" "${session_args[@]}"
    fi

    # In order to ensure only specified windows are created, we move the
    # default window to position 999, and later remove it with the
    # `finalize_and_go_to_session` function.
    local first_window_index=$(__get_first_window_index)
    tmuxifier-tmux move-window \
      -s "$session:$first_window_index" -t "$session:999"

    # Session created, return ok exit status.
    return 0
  fi
  # Session already existed, return error exit status.
  return 1
}

# Finalize session creation and then switch to it if needed.
#
# When the session is created, it leaves a unused window in position #999,
# this is the default window which was created with the session, but it's also
# a window that was not explicitly created. Hence we kill it.
#
# If the session was created, we've already been switched to it. If it was not
# created, the session already exists, and we'll need to specifically switch
# to it here.
#
finalize_and_go_to_session() {
  ! tmuxifier-tmux kill-window -t "$session:999" 2>/dev/null
  if [[ "$(tmuxifier-current-session)" != "$session" ]]; then
    __go_to_session
  fi
}


#
# Internal functions
#

# Expands given path.
#
# Example:
#
#   $ __expand_path "~/Projects"
#   /Users/jimeh/Projects
#
__expand_path() {
  echo $(eval echo "$@")
}

__get_first_window_index() {
  local index=$(tmuxifier-tmux list-windows -t "$session:" \
    -F "#{window_index}" 2>/dev/null)

  if [ -n "$index" ]; then
    echo "$index" | head -1
  else
    echo "0"
  fi
}

__go_to_session() {
  if [ -z "$TMUX" ]; then
    tmuxifier-tmux -u attach-session -t "$session:"
  else
    tmuxifier-tmux -u switch-client -t "$session:"
  fi
}

__go_to_window_or_session_path() {
  local window_or_session_root=${window_root-$session_root}
  if [ -n "$window_or_session_root" ]; then
    run_cmd "cd \"$window_or_session_root\""
    run_cmd "clear"
  fi
}
