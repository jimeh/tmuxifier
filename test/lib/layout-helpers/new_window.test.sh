#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# new_window() tests.
#

# When called without arguments, creates new window.
create-test-session
stub __go_to_window_or_session_path
assert "test-socket-window-count" "1"
new_window
assert "test-socket-window-count" "2"
assert "stub_called_times __go_to_window_or_session_path" "1"
restore __go_to_window_or_session_path
kill-test-session

# When called with name argument, creates new window with specified name.
create-test-session
stub __go_to_window_or_session_path
assert "test-socket-window-count yippieezzz" "0"
new_window "yippieezzz"
assert "test-socket-window-count" "2"
assert "test-socket-window-count yippieezzz" "1"
restore __go_to_window_or_session_path
kill-test-session

# When called with name and command argument, creates new window with
# specified name and executes given command.
rm "/tmp/tmuxifier-new_window-test" &> /dev/null
create-test-session
stub __go_to_window_or_session_path
new_window "foobardoo" "touch /tmp/tmuxifier-new_window-test; bash"
assert "test-socket-window-count" "2"
assert "test-socket-window-count foobardoo" "1"
sleep 0.1 # attempt to avoid timing issue causing flicker
assert_raises 'test -f "/tmp/tmuxifier-new_window-test"' 0
restore __go_to_window_or_session_path
kill-test-session
rm "/tmp/tmuxifier-new_window-test" &> /dev/null

# When called ensure it sets the $window variable to the index of the newly
# created window.
unset window
create-test-session
stub __go_to_window_or_session_path
new_window "foo"
assert "echo $window" "1"
new_window
assert "echo $window" "2"
new_window "bar"
assert "echo $window" "3"
restore __go_to_window_or_session_path
kill-test-session
unset window

# End of tests.
assert_end "new_window()"
