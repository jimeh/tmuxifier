calling-help() {
  if [[ " $@ " != *" --help "* ]] && [[ " $@ " != *" -h "* ]]; then
    return 1
  fi
}

calling-complete() {
  if [[ " $@ " != *" --complete "* ]]; then
    return 1
  fi
}
