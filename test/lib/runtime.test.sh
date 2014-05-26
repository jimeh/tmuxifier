#! /usr/bin/env bash
source "../test-helper.sh"

#
# runtime.sh tests.
#

source "${root}/lib/runtime.sh"

# We assume env.sh has been sourced if $TMUXIFIER_LAYOUT_PATH has been set.
assert 'echo $TMUXIFIER_LAYOUT_PATH' "${TMUXIFIER}/layouts"

# We ensure $session_root is set to $HOME by default.
assert 'echo $session_root' "$HOME"

# We assume layout-helpers.sh has been sourced if a few of them are available.
for helper in new_window split_v split_h select_window select_pane; do
  assert "type $helper | head -1" "$helper is a function"
done


# End of tests.
assert_end "runtime.sh"
