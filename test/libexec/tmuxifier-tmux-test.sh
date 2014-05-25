#! /usr/bin/env bash
source "../test-helper.sh"
source "${root}/lib/util.sh"

#
# tmuxifier-tmux tests.
#

# Setup.
libexec="${root}/libexec"
realTMUX="$TMUX"
unset TMUX
export TMUXIFIER_TMUX_OPTS="-L tmuxifier-tests"
tmux $TMUXIFIER_TMUX_OPTS new -d -s foobar
tmux $TMUXIFIER_TMUX_OPTS new -d -s dude

# Passes all arguments to Tmux.
assert "${libexec}/tmuxifier-tmux list-sessions -F \"- #{session_name}\"" \
       "- dude\n- foobar"

# Tear down.
tmux $TMUXIFIER_TMUX_OPTS kill-server
unset TMUXIFIER_TMUX_OPTS
TMUX="$realTMUX"
unset realTMUX

# End of tests.
assert_end "tmuxifier-tmux"
