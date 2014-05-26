#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# tmux() tests.
#

# Passes all arguments to tmuxifier-tmux.
stub tmuxifier-tmux
tmux -V
tmux --help
tmux new -s dude
assert_raises "stub_called_with tmuxifier-tmux -V" 0
assert_raises "stub_called_with tmuxifier-tmux --help" 0
assert_raises "stub_called_with tmuxifier-tmux new -s dude" 0
restore tmuxifier-tmux

# End of tests.
assert_end "tmux()"
