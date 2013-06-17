# Set Tmuxifier root path if needed.
if ( ! $?TMUXIFIER ) then
  setenv TMUXIFIER "${HOME}/.tmuxifier"
endif

# Add `bin` directroy to `$path` if needed.
if ( ! (" $path " =~ "* $TMUXIFIER/bin *" ) ) then
  set path = ( $TMUXIFIER/bin $path )
endif

# If `tmuxifier` is available, and `$TMUXIFIER_NO_COMPLETE` is not set, then
# load Tmuxifier shell completion.
if ( ! $?TMUXIFIER_NO_COMPLETE ) then
  which tmuxifier > /dev/null && source "$TMUXIFIER/completion/tmuxifier.tcsh"
endif
