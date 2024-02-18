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
  if [ -n "$1" ]; then local winarg=(-n "$1"); fi
  if [ -n "$2" ]; then local command=("$2"); fi

  tmuxifier-tmux new-window -t "$session:" "${winarg[@]}" "${command[@]}"

  # Disable renaming if a window name was given.
  if [ -n "$1" ]; then tmuxifier-tmux set-option -t "$1" allow-rename off; fi

  window="$(__get_current_window_index)"
  __go_to_window_or_session_path
}

# Split current window/pane vertically.
#
# Arguments:
#   - $1: (optional) Percentage of frame the new pane will use.
#   - $2: (optional) Target pane ID to split in current window.
#
split_v() {
  if [ "$(tmuxifier-tmux-version "3.0")" == ">" ]; then
    # Tmux 3.1 and later.
    if [ -n "$1" ]; then local percentage=(-l "$1"'%'); fi
  else
    if [ -n "$1" ]; then local percentage=(-p "$1"); fi
  fi
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
  if [ "$(tmuxifier-tmux-version "3.0")" == ">" ]; then
    # Tmux 3.1 and later.
    if [ -n "$1" ]; then local percentage=(-l "$1"'%'); fi
  else
    if [ -n "$1" ]; then local percentage=(-p "$1"); fi
  fi
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
  window="$(__get_current_window_index)"
}

# Select a specific pane in the current window.
#
# Arguments:
#   - $1: Pane ID to select.
#
select_pane() {
  tmuxifier-tmux select-pane -t "$session:$window.$1"
}

# Balance windows vertically with the "even-vertical" layout.
#
# Arguments:
#   - $1: (optional) Window ID or name to operate on.
#
balance_windows_vertical() {
  tmuxifier-tmux select-layout -t "$session:${1:-$window}" even-vertical
}

# Balance windows horizontally with the "even-horizontal" layout.
#
# Arguments:
#   - $1: (optional) Window ID or name to operate on.
#
balance_windows_horizontal() {
  tmuxifier-tmux select-layout -t "$session:${1:-$window}" even-horizontal
}

# Turn on synchronize-panes in a window.
#
# Arguments:
#   - $1: (optional) Window ID or name to operate on.
#
synchronize_on() {
  tmuxifier-tmux set-window-option -t "$session:${1:-$window}" \
                 synchronize-panes on
}

# Turn off synchronize-panes in a window.
#
# Arguments:
#   - $1: (optional) Window ID or name to operate on.
#
synchronize_off() {
  tmuxifier-tmux set-window-option -t "$session:${1:-$window}" \
                 synchronize-panes off
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
  local file
  if [ "${1#*/}" = "$1" ]; then
    # There's no slash in the path.
    if [ -f "$TMUXIFIER_LAYOUT_PATH/$1.session.sh" ] || [ ! -f "$1" ]; then
      file="$TMUXIFIER_LAYOUT_PATH/$1.session.sh"
    else
      # bash's 'source' requires an slash in the filename to not use $PATH.
      file="./$1"
    fi
  else
    file="$1"
  fi

  if ! [ -f "$file" ]; then
    echo "\"$1\" session layout not found." >&2
    return 1
  fi

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
  if tmuxifier-tmux list-sessions | grep -q "^$session:"; then
    return 1
  fi

  # Tmux 1.8 and earlier.
  if [ "$(tmuxifier-tmux-version "1.9")" == "<" ]; then
    # Create the new session.
    env TMUX="" tmuxifier-tmux new-session -d -s "$session"

    # Set default-path for session
    if [ -n "$session_root" ] && [ -d "$session_root" ]; then
      cd "$session_root"

      $set_default_path && tmuxifier-tmux \
        set-option -t "$session:" \
        default-path "$session_root" 1>/dev/null
    fi

  # Tmux 1.9 and later.
  else
    if $set_default_path; then
      local session_args=(-c "$session_root")
    fi

    env TMUX="" tmuxifier-tmux new-session \
      -d -s "$session" "${session_args[@]}"
  fi

  if $set_default_path && [[ "$session_root" != "$HOME" ]]; then
    tmuxifier-tmux setenv -t "$session:" \
      TMUXIFIER_SESSION_ROOT "$session_root"
  fi

  # In order to ensure only specified windows are created, we move the
  # default window to position 999, and later remove it with the
  # `finalize_and_go_to_session` function.
  local first_window_index=$(__get_first_window_index)
  tmuxifier-tmux move-window \
    -s "$session:$first_window_index" -t "$session:999"
}

# Finalize session creation and then switch to it if needed.
#
# When the session is created, it leaves a unused window in position #999,
# this is the default window which was created with the session, but it's also
# a window that was not explicitly created. Hence we kill it.
#
# If the session was created, we've already been switched to it. If it was not
# created, but already existed, then we'll need to specifically switch to it.
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

__get_current_window_index() {
  local lookup=$(tmuxifier-tmux list-windows -t "$session:" \
    -F "#{window_active}:#{window_index}" 2>/dev/null | grep "^1:")

  if [ -n "$lookup" ]; then
    echo "${lookup/1:}"
  fi
}

__go_to_session() {
  if [ -z "$TMUX" ]; then
    tmuxifier-tmux $TMUXIFIER_TMUX_ITERM_ATTACH -u \
      attach-session -t "$session:"
  else
    tmuxifier-tmux -u switch-client -t "$session:"
  fi
}

__go_to_window_or_session_path() {
  local target_path

  if [ -n "$window_root" ]; then
    target_path="$window_root"
  elif [ -n "$TMUXIFIER_SESSION_ROOT" ]; then
    target_path="$TMUXIFIER_SESSION_ROOT"
  elif [ -n "$session_root" ]; then
    target_path="$session_root"
  fi

  # local window_or_session_root=${window_root-$session_root}
  if [ -n "$target_path" ]; then
    run_cmd "cd \"$target_path\""
    run_cmd "clear"
  fi
}
