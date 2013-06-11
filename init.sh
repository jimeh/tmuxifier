# Set/fix Tmuxifier root path if needed.
if [ -z "${TMUXIFIER}" ]; then
  export TMUXIFIER="${HOME}/.tmuxifier"
else
  export TMUXIFIER="${TMUXIFIER%/}"
fi

# Add `bin` directroy to `$PATH`.
if [[ ":$PATH:" != *":$TMUXIFIER/bin:"* ]]; then
  export PATH="$TMUXIFIER/bin:$PATH"
fi

# If `tmuxifier` is available, and `$TMUXIFIER_NO_COMPLETE` is not set, then
# load Tmuxifier shell completion.
if [ -n "$(command -v "tmuxifier")" ] && [ -z "$TMUXIFIER_NO_COMPLETE" ]; then
  if [ -n "$BASH_VERSION" ]; then
    source "$TMUXIFIER/completion/tmuxifier.bash"
  elif [ -n "$ZSH_VERSION" ]; then
    source "$TMUXIFIER/completion/tmuxifier.zsh"
  fi
fi
