#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# __get_current_window_index() tests.
#

# When current window is the first and only window.
create-test-session
assert "__get_current_window_index" "0"
kill-test-session

# When creating a second window.
create-test-session
test-socket-tmux new-window -t "$session:1"
assert "__get_current_window_index" "1"
kill-test-session

# When creating a second window and then switching back to the first window.
create-test-session
test-socket-tmux new-window -t "$session:1"
test-socket-tmux select-window -t "$session:0"
assert "__get_current_window_index" "0"
kill-test-session

# When creating multiples windows and switching between them randomly.
create-test-session
assert "__get_current_window_index" "0"
test-socket-tmux new-window -t "$session:1"
assert "__get_current_window_index" "1"
test-socket-tmux new-window -t "$session:2"
assert "__get_current_window_index" "2"
test-socket-tmux new-window -t "$session:3"
assert "__get_current_window_index" "3"
test-socket-tmux select-window -t "$session:1"
assert "__get_current_window_index" "1"
test-socket-tmux select-window -t "$session:0"
assert "__get_current_window_index" "0"
test-socket-tmux select-window -t "$session:3"
assert "__get_current_window_index" "3"
test-socket-tmux select-window -t "$session:2"
assert "__get_current_window_index" "2"
kill-test-session


# End of tests.
assert_end "__get_current_window_index()"
