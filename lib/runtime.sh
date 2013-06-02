#
# Load up runtime environment for session and window layout files.
#

# Load tmuxifier environment.
source "$TMUXIFIER/lib/env.sh"

# Setup default variables.
session_root="$HOME"

# Load layout helper functions.
source "$TMUXIFIER/lib/layout-helpers.sh"
