# Setup layout path.
if [ -z "${TMUXIFIER_LAYOUT_PATH}" ]; then
  export TMUXIFIER_LAYOUT_PATH="${TMUXIFIER}/layouts"
else
  export TMUXIFIER_LAYOUT_PATH="${TMUXIFIER_LAYOUT_PATH%/}"
fi

# This works around a bug in tmux when redirecting to /dev/null
# See http://sourceforge.net/tracker/?func=detail&aid=3489496&group_id=200378&atid=973262
export EVENT_NOEPOLL=1
