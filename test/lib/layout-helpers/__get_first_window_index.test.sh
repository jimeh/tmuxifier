#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# __get_first_window_index() tests.
#

# When first window has a index of 0.
create-test-session
assert "__get_first_window_index" "0"
kill-test-session

# When first window has a index of 1.
create-test-session
test-socket-tmux new-window -t "$session:1"
test-socket-tmux kill-window -t "$session:0"
assert "__get_first_window_index" "1"
kill-test-session

# When first window has a index of 2.
create-test-session
test-socket-tmux new-window -t "$session:2"
test-socket-tmux kill-window -t "$session:0"
assert "__get_first_window_index" "2"
kill-test-session


# End of tests.
assert_end "__get_first_window_index()"
