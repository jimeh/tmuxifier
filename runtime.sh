#
# Load up runtime environment for session and window layout files.
#

# Load tmuxifier environment.
source "$TMUXIFIER/env.sh"

# Setup default variables.
session_root="$HOME"

# Load layout helper functions.
source "$TMUXIFIER/layout-helpers.sh"


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

__go_to_session() {
  if [ -z $TMUX ]; then
    tmux -u attach-session -t "$session"
  else
    tmux -u switch-client -t "$session"
  fi
}
