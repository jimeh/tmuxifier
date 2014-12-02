#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# __go_to_session() tests.
#

# Setup.
session="tmuxifier-test-session"

# When TMUX is not set, attach to $session.
stub tmuxifier-tmux
__go_to_session
assert_raises \
  "stub_called_with tmuxifier-tmux -u attach-session -t \"${session}:\"" 0
restore tmuxifier-tmux

# When TMUXIFIER_TMUX_ITERM_ATTACH is set, pass it in as first argument(s) to
# tmuxifier-tmux
TMUXIFIER_TMUX_ITERM_ATTACH="-CC"
stub tmuxifier-tmux
__go_to_session
assert_raises \
  "stub_called_with tmuxifier-tmux -CC -u attach-session -t \"${session}:\"" 0
restore tmuxifier-tmux
unset TMUXIFIER_TMUX_ITERM_ATTACH

# When TMUX is set, switch to $session.
TMUX="/tmp/tmux-501/default,1203,0"
stub tmuxifier-tmux
__go_to_session
assert_raises \
  "stub_called_with tmuxifier-tmux -u switch-client -t \"${session}:\"" 0
restore tmuxifier-tmux
unset TMUX

# Tear down.
unset session

# End of tests.
assert_end "__go_to_session()"
