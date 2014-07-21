[ -n "$TEST_DEBUG" ] && set -x

resolve_link() {
  $(type -p greadlink readlink | head -1) $1
}

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

# Find and store path to Tmux binary.
TMUX_BIN="$(command -v tmux)"

# Set testroot variable.
testroot="$(abs_dirname "$BASH_SOURCE")"

# Set root variable.
root="$(abs_dirname "$testroot/../..")"

# Set TMUXIFIER environment variable.
TMUXIFIER="$root"

# Setup PATH environment variable.
PATH="$root/bin:$root/libexec:$PATH"

# Unset TMUX environment variable, tests assume they're not running within
# Tmux.
unset TMUX

# Unset various Tmuxifier environment variables to prevent a local install of
# Tmuxifier interfering with tests.
unset TMUXIFIER_LAYOUT_PATH
unset TMUXIFIER_TMUX_OPTS
unset TMUXIFIER_NO_COMPLETE

# Include assert.sh and stub.sh libraries.
source "${testroot}/assert.sh"
source "${testroot}/stub.sh"


#
# Test Helpers
#

test-socket-tmux() {
  export TMUXIFIER_TMUX_OPTS="-L tmuxifier-tests"
  "$TMUX_BIN" $TMUXIFIER_TMUX_OPTS $@
}

create-test-session() {
  session="$1"
  if [ -z "$session" ]; then session="test"; fi

  test-socket-tmux new-session -d -s "$session"
}

kill-test-session() {
  local target="$1"
  if [ -z "$target" ]; then target="$session"; fi

  test-socket-tmux kill-session -t "$target"
}

kill-test-server() {
  test-socket-tmux kill-server
  unset TMUXIFIER_TMUX_OPTS
  unset session
}

test-socket-window-count() {
  local list="$(test-socket-tmux list-windows)"
  if [ -n "$1" ]; then
    echo "$list" | grep $1 | wc -l | awk '{print $1}'
  else
    echo "$list" | wc -l | awk '{print $1}'
  fi
}
