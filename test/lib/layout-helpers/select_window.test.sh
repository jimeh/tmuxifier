#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# select_window() tests.
#

window_list() {
  test-socket-tmux list-windows -t "$session:" \
    -F "#{window_active}:#{window_index}" 2>/dev/null
}

# Selects given window when passed a window index
create-test-session
test-socket-tmux new-window -t "$session:1"
test-socket-tmux new-window -t "$session:2"
select_window 0
assert "window_list | grep '^1:'" "1:0"
select_window 1
assert "window_list | grep '^1:'" "1:1"
select_window 2
assert "window_list | grep '^1:'" "1:2"
kill-test-session

# Selects given window when passed a window name
create-test-session
test-socket-tmux new-window -t "$session:1" -n "foo"
test-socket-tmux new-window -t "$session:2" -n "bar"
select_window foo
assert "window_list | grep '^1:'" "1:1"
select_window bar
assert "window_list | grep '^1:'" "1:2"
kill-test-session


# When called ensure it sets the $window variable to the index of the newly
# created window.
unset window
create-test-session
test-socket-tmux new-window -t "$session:1" -n "foo"
test-socket-tmux new-window -t "$session:2" -n "bar"
select_window "foo"
assert "echo $window" "1"
select_window "bar"
assert "echo $window" "2"
select_window 1
assert "echo $window" "1"
select_window 2
assert "echo $window" "2"
kill-test-session
unset window

# End of tests.
assert_end "select_window()"
