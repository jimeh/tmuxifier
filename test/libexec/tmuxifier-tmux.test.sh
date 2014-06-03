#! /usr/bin/env bash
source "../test-helper.sh"
source "${root}/lib/util.sh"

#
# tmuxifier-tmux tests.
#

# Setup.
libexec="${root}/libexec"
test-socket-tmux new-session -d -s foobar
test-socket-tmux new-session -d -s dude

# Passes all arguments to Tmux.
assert "${libexec}/tmuxifier-tmux list-sessions -F \"- #{session_name}\"" \
       "- dude\n- foobar"

# Tear down.
kill-test-server

# End of tests.
assert_end "tmuxifier-tmux"
