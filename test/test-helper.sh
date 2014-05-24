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

# Set testroot variable.
testroot="$(abs_dirname "$BASH_SOURCE")"

# Set root variable.
root="$(abs_dirname "$testroot/../..")"

# Set TMUXIFIER environment variable
TMUXIFIER="$root"

# Unset various Tmuxifier environment variables to prevent a local install of
# Tmuxifier interfering with tests.
unset TMUXIFIER_LAYOUT_PATH
unset TMUXIFIER_TMUX_OPTS
unset TMUXIFIER_NO_COMPLETE

# Include assert.sh and stub.sh libraries.
source "${testroot}/assert.sh"
source "${testroot}/stub.sh"
