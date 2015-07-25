#! /usr/bin/env bash
source "../../test-helper.sh"
source "${root}/lib/layout-helpers.sh"

#
# __go_to_window_or_session_path() tests.
#

# When neither $window_root or $session_root are set, does nothing.
stub run_cmd
__go_to_window_or_session_path
assert "stub_called_times run_cmd" "0"
restore run_cmd


# When only $window_root is set, runs cd to $window_root path.
stub run_cmd
window_root="/tmp"
__go_to_window_or_session_path
assert 'stub_called_with_times run_cmd cd \"/tmp\"' "1"
assert 'stub_called_with_times run_cmd clear' "1"
unset window_root
restore run_cmd


# When only $TMUXIFIER_SESSION_ROOT is set, runs cd to $TMUXIFIER_SESSION_ROOT
# path.
stub run_cmd
TMUXIFIER_SESSION_ROOT="/opt"
__go_to_window_or_session_path
assert 'stub_called_with_times run_cmd cd \"/opt\"' "1"
assert 'stub_called_with_times run_cmd clear' "1"
unset TMUXIFIER_SESSION_ROOT
restore run_cmd


# When only $session_root is set, runs cd to $session_root path.
stub run_cmd
session_root="/usr"
__go_to_window_or_session_path
assert 'stub_called_with_times run_cmd cd \"/usr\"' "1"
assert 'stub_called_with_times run_cmd clear' "1"
unset session_root
restore run_cmd


# When $window_root and $session_root are set, runs cd to $window_root path.
stub run_cmd
window_root="/tmp"
session_root="/usr"
__go_to_window_or_session_path
assert 'stub_called_with_times run_cmd cd \"/tmp\"' "1"
assert 'stub_called_with_times run_cmd clear' "1"
unset window_root
unset session_root
restore run_cmd


# When $TMUXIFIER_SESSION_ROOT and $session_root are set, runs cd to
# $TMUXIFIER_SESSION_ROOT path.
stub run_cmd
TMUXIFIER_SESSION_ROOT="/opt"
session_root="/usr"
__go_to_window_or_session_path
assert 'stub_called_with_times run_cmd cd \"/opt\"' "1"
assert 'stub_called_with_times run_cmd clear' "1"
unset TMUXIFIER_SESSION_ROOT
unset session_root
restore run_cmd


# When $window_root, $TMUXIFIER_SESSION_ROOT, and $session_root are set, runs
# cd to $window_root path.
stub run_cmd
window_root="/tmp"
TMUXIFIER_SESSION_ROOT="/opt"
session_root="/usr"
__go_to_window_or_session_path
assert 'stub_called_with_times run_cmd cd \"/tmp\"' "1"
assert 'stub_called_with_times run_cmd clear' "1"
unset window_root
unset TMUXIFIER_SESSION_ROOT
unset session_root
restore run_cmd


# End of tests.
assert_end "__go_to_window_or_session_path()"
