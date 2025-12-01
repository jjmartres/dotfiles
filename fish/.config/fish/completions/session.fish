# Completions for session function

# Disable file completion by default
complete -c session -f

# Help options (available everywhere)
complete -c session -s h -l help -d "Show help message"

# Subcommands (only when no subcommand is given yet)
complete -c session -n "not __fish_seen_subcommand_from ls list kill rm help" -a ls -d "List all sessions"
complete -c session -n "not __fish_seen_subcommand_from ls list kill rm help" -a list -d "List all sessions"
complete -c session -n "not __fish_seen_subcommand_from ls list kill rm help" -a kill -d "Kill a specific session"
complete -c session -n "not __fish_seen_subcommand_from ls list kill rm help" -a rm -d "Delete a specific session"
complete -c session -n "not __fish_seen_subcommand_from ls list kill rm help" -a help -d "Show help message"

# Complete session names for kill subcommand
complete -c session -n "__fish_seen_subcommand_from kill" -a "(zellij list-sessions -n 2>/dev/null | string match -r '^\\S+' | string trim)" -d "Session name"

# Complete session names for rm subcommand
complete -c session -n "__fish_seen_subcommand_from rm" -a "(zellij list-sessions -n 2>/dev/null | string match -r '^\\S+' | string trim)" -d "Session name"

# Complete existing session names when attaching (no subcommand given)
complete -c session -n "not __fish_seen_subcommand_from ls list kill rm help; and test (count (commandline -opc)) -eq 1" -a "(zellij list-sessions -n 2>/dev/null | string match -r '^\\S+' | string trim)" -d "Existing session"
