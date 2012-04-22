if [[ ! -o interactive ]]; then
    return
fi

compctl -K _tmuxifier tmuxifier

_tmuxifier() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(tmuxifier commands)"
  else
    completions="$(tmuxifier completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
