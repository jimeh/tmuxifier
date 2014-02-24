
set -l cmd_load_session  'load-session s'
set -l cmd_load_window   'load-window w'
set -l cmd_list          'list l'
set -l cmd_list_sessions 'list-sessions ls'
set -l cmd_list_windows  'list-windows lw'
set -l cmd_new_session   'new-session ns'
set -l cmd_new_window    'new-window nw'
set -l cmd_edit_session  'edit-session es'
set -l cmd_edit_window   'edit-window ew'
set -l cmd_commands      'commands'
set -l cmd_version       'version'
set -l cmd_help          'help'

complete -c tmuxifier -x

# Commands
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_load_session  -d 'Load the specified session layout.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_load_window   -d 'Load the specified window layout into current session.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_list          -d 'List all session and window layouts.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_list_sessions -d 'List session layouts.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_list_windows  -d 'List window layouts.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_new_session   -d 'Create new session layout and open it with $EDITOR.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_new_window    -d 'Create new window layout and open it with $EDITOR.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_edit_session  -d 'Edit specified session layout with $EDITOR.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_edit_window   -d 'Edit specified window layout with $EDITOR.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_commands      -d 'List all tmuxifier commands.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_version       -d 'Print Tmuxifier version.'
complete -c tmuxifier -n '__fish_use_subcommand' -a $cmd_help          -d 'Show this message.'

# Complete subcommands
complete -c tmuxifier -x -n "__fish_seen_subcommand_from $cmd_load_session" -a '(tmuxifier list-sessions)' -d 'session-template'
complete -c tmuxifier -x -n "__fish_seen_subcommand_from $cmd_load_window"  -a '(tmuxifier list-windows)'  -d 'window-template'
complete -c tmuxifier -x -n "__fish_seen_subcommand_from $cmd_edit_session" -a '(tmuxifier list-sessions)' -d 'session-template'
complete -c tmuxifier -x -n "__fish_seen_subcommand_from $cmd_edit_window"  -a '(tmuxifier list-windows)'  -d 'window-template'

