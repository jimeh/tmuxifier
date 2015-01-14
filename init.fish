# Set/fix Tmuxifier root path if needed.
if test -z $TMUXIFIER
  set -gx TMUXIFIER "$HOME/.tmuxifier"
end

# Add `bin` directroy to `$PATH`.
if not contains "$TMUXIFIER/bin" $PATH
  set -gx PATH "$TMUXIFIER/bin" $PATH
end

# If `tmuxifier` is available, and `$TMUXIFIER_NO_COMPLETE` is not set, then
# load Tmuxifier shell completion.
if test -n (which tmuxifier); and test -z $TMUXIFIER_NO_COMPLETE
  . "$TMUXIFIER/completion/tmuxifier.fish"
end


