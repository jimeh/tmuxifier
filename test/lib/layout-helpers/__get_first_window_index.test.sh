#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# __get_first_window_index() tests.
#

# Setup.
libexec="${root}/libexec"
export TMUXIFIER_TMUX_OPTS="-L tmuxifier-tests"
session="test"


# When first window has a index of 0.
tmux $TMUXIFIER_TMUX_OPTS new-session -d -s $session
assert "__get_first_window_index" "0"
tmux $TMUXIFIER_TMUX_OPTS kill-server

# When first window has a index of 1.
tmux $TMUXIFIER_TMUX_OPTS new-session -d -s $session
tmux $TMUXIFIER_TMUX_OPTS new-window -t "$session:1"
tmux $TMUXIFIER_TMUX_OPTS kill-window -t "$session:0"
assert "__get_first_window_index" "1"
tmux $TMUXIFIER_TMUX_OPTS kill-server

# When first window has a index of 2.
tmux $TMUXIFIER_TMUX_OPTS new-session -d -s $session
tmux $TMUXIFIER_TMUX_OPTS new-window -t "$session:2"
tmux $TMUXIFIER_TMUX_OPTS kill-window -t "$session:0"
assert "__get_first_window_index" "2"
tmux $TMUXIFIER_TMUX_OPTS kill-server


# Tear down.
unset TMUXIFIER_TMUX_OPTS
unset session

# End of tests.
assert_end "__get_first_window_index()"
