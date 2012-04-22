# Set tmuxifier root path.
if [ -z "${TMUXIFIER}" ]; then
  export TMUXIFIER="${HOME}/.tmuxifier"
else
  export TMUXIFIER="${TMUXIFIER%/}"
fi

# Add `bin` directroy to `$PATH`.
export PATH="$TMUXIFIER/bin:$PATH"

# If `tmuxifier` is available, and `$TMUXIFIER_NO_COMPLETE` is not set, then
# load tmuxifier shell completion.
if [ ! -z $(command -v "tmuxifier") ] && [ -z "$TMUXIFIER_NO_COMPLETE" ]; then
  if [ -n "$BASH_VERSION" ]; then
    source "$TMUXIFIER/completion/tmuxifier.bash"
  elif [ -n "$ZSH_VERSION" ]; then
    source "$TMUXIFIER/completion/tmuxifier.zsh"
  fi
fi
