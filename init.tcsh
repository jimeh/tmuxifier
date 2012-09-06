# Set tmuxifier root path.
if ( ! $?TMUXIFIER ) then
  setenv TMUXIFIER "${HOME}/.tmuxifier"
endif

# Add `bin` directroy to `$PATH`.
set path = ( $TMUXIFIER/bin $path )

# If `tmuxifier` is available, and `$TMUXIFIER_NO_COMPLETE` is not set, then
# load tmuxifier shell completion.
if ( ! $?TMUXIFIER_NO_COMPLETE ) then
  which tmuxifier > /dev/null && source "$TMUXIFIER/completion/tmuxifier.tcsh"
endif
