#! /usr/bin/env bash
source "../test-helper.sh"

#
# env.sh tests.
#

# Setup
TMUXIFIER="/path/to/tmuxifier"
unset TMUXIFIER_LAYOUT_PATH

# When TMUXIFIER_LAYOUT_PATH is not set.
source "../../lib/env.sh"
assert 'echo $TMUXIFIER_LAYOUT_PATH' "${TMUXIFIER}/layouts"

# When TMUXIFIER_LAYOUT_PATH is set and has a trailing slash.
TMUXIFIER_LAYOUT_PATH="/path/to/layouts/"
source "../../lib/env.sh"
assert 'echo $TMUXIFIER_LAYOUT_PATH' "/path/to/layouts"
unset TMUXIFIER_LAYOUT_PATH

# When TMUXIFIER_LAYOUT_PATH is set and does not have a trailing slash.
TMUXIFIER_LAYOUT_PATH="/path/to/layouts"
source "../../lib/env.sh"
assert 'echo $TMUXIFIER_LAYOUT_PATH' "/path/to/layouts"
unset TMUXIFIER_LAYOUT_PATH


# Teardown
unset TMUXIFIER

# End of tests.
assert_end "env.sh"
