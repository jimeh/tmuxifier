_tmuxifier() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=($(compgen -W "$(tmuxifier commands)" -- "$word"))
  else
    local command="${COMP_WORDS[1]}"
    local completions
    completions="$(tmuxifier completions "$command")"
    COMPREPLY=($(compgen -W "$completions" -- "$word"))
  fi
}

complete -F _tmuxifier tmuxifier
