# Setup layout path.
if [ -z "${TMUXIFIER_LAYOUT_PATH}" ]; then
  export TMUXIFIER_LAYOUT_PATH="${TMUXIFIER}/layouts"
else
  export TMUXIFIER_LAYOUT_PATH="${TMUXIFIER_LAYOUT_PATH%/}"
fi

# Setup session base path.
if [ -z "${TMUXIFIER_SESSION_BASE_PATH}" ]; then
  export TMUXIFIER_SESSION_BASE_PATH="~/Projects"
else
  export TMUXIFIER_SESSION_BASE_PATH="${TMUXIFIER_SESSION_BASE_PATH%/}"
fi

# Setup template path.
if [ -z "${TMUXIFIER_TEMPLATE_PATH}" ]; then
  export TMUXIFIER_TEMPLATE_PATH="${TMUXIFIER}/templates"
else
  export TMUXIFIER_TEMPLATE_PATH="${TMUXIFIER_TEMPLATE_PATH%/}"
fi

# Setup session template name.
if [ -z "${TMUXIFIER_SESSION_TEMPLATE_NAME}" ]; then
  export TMUXIFIER_SESSION_TEMPLATE_NAME="session"
else
  export TMUXIFIER_SESSION_TEMPLATE_NAME="${TMUXIFIER_SESSION_TEMPLATE_NAME%.sh}"
fi

# Setup window template name.
if [ -z "${TMUXIFIER_WINDOW_TEMPLATE_NAME}" ]; then
  export TMUXIFIER_WINDOW_TEMPLATE_NAME="window"
else
  export TMUXIFIER_WINDOW_TEMPLATE_NAME="${TMUXIFIER_WINDOW_TEMPLATE_NAME%.sh}"
fi
