[ -n "$TEST_DEBUG" ] && set -x

# Set testroot variable.
testroot="$(dirname "$BASH_SOURCE")"

# Set TMUXIFIER environment variable
TMUXIFIER="$(dirname "$testroot")"

# Unset various Tmuxifier environment variables to prevent a local install of
# Tmuxifier interfering with tests.
unset TMUXIFIER_LAYOUT_PATH
unset TMUXIFIER_TMUX_OPTS
unset TMUXIFIER_NO_COMPLETE

# Include assert.sh and stub.sh libraries.
source "${testroot}/assert.sh"
source "${testroot}/stub.sh"
