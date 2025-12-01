function session --description "Create or attach to a Zellij session with session layout"
    # Handle special commands
    if test (count $argv) -gt 0
        switch $argv[1]
            case -h --help help
                echo "Usage: session [COMMAND|SESSION_NAME]"
                echo ""
                echo "Commands:"
                echo "  session              Attach/create session using current directory name"
                echo "  session <name>       Attach/create session with custom name"
                echo "  session ls|list      Interactive session picker with fzf"
                echo "  session ls --plain   List all sessions (plain output)"
                echo "  session kill <name>  Kill a specific session"
                echo "  session help         Show this help message"
                echo ""
                echo "Examples:"
                echo "  session              # Creates session named after current directory"
                echo "  session myproject    # Creates/attaches to 'myproject'"
                echo "  session ls           # Interactive session picker"
                echo "  session kill old     # Kills session named 'old'"
                echo "  session rm old       # Deletes session named 'old'"
                return
            case ls list
                # Check for --plain flag
                if test "$argv[2]" = --plain -o "$argv[2]" = -p
                    zellij list-sessions -s
                    return
                end

                # Check if fzf is available
                if not command -v fzf >/dev/null
                    echo "fzf not found, showing plain list:"
                    zellij list-sessions -s
                    return
                end

                # Check if we're inside Zellij
                if set -q ZELLIJ
                    # Create a temporary file to store the selection
                    set -l temp_file (mktemp)

                    # Run fzf in a floating pane and save selection to temp file
                    zellij run --floating --close-on-exit -- fish -c "
                        zellij list-sessions -n 2>/dev/null | fzf \
                            --prompt='󰆍 Select session: ' \
                            --height=100% \
                            --reverse \
                            --border=rounded \
                            --header='[enter] attach • [esc] cancel' \
                            --color='header:italic:cyan,prompt:bold:green' \
                            > $temp_file
                    "

                    # Read the selection
                    if test -s $temp_file
                        set -l selected_session (cat $temp_file)
                        set -l session_name (echo $selected_session | awk '{print $1}')
                        rm $temp_file
                        echo "Attaching to session: $session_name"
                        zellij attach $session_name
                    else
                        rm $temp_file
                        echo "No session selected"
                    end
                else
                    # Not in Zellij, use regular fzf
                    set -l selected_session (zellij list-sessions -n 2>/dev/null | fzf \
                        --prompt="󰆍 Select session: " \
                        --height=50% \
                        --reverse \
                        --border=rounded \
                        --header="[enter] attach • [esc] cancel" \
                        --color="header:italic:cyan,prompt:bold:green")

                    if test -n "$selected_session"
                        set -l session_name (echo $selected_session | awk '{print $1}')
                        echo "Attaching to session: $session_name"
                        zellij attach $session_name
                    else
                        echo "No session selected"
                    end
                end
                return
            case kill
                if test (count $argv) -lt 2
                    echo "Error: session kill requires a session name"
                    echo "Usage: session kill <session_name>"
                    echo "Tip: Run 'session ls' to see available sessions"
                    return 1
                end
                zellij kill-session $argv[2]
                return
            case rm
                if test (count $argv) -lt 2
                    echo "Error: session rm requires a session name"
                    echo "Usage: session rm <session_name>"
                    echo "Tip: Run 'session ls' to see available sessions"
                    return 1
                end
                zellij delete-session $argv[2]
                return
        end
    end
    # Setup project notes and gitignore
    set -l notes_file ".project_notes.md"
    set -l gitignore_file ".gitignore"
    # Create project notes file if it doesn't exist
    if not test -f $notes_file
        echo "# Project Notes" >$notes_file
        echo "" >>$notes_file
        echo "> Created on: "(date +"%Y-%m-%d %H:%M:%S") >>$notes_file
        echo "Created $notes_file"
    end
    # Ensure .gitignore exists
    if not test -f $gitignore_file
        touch $gitignore_file
        echo "Created $gitignore_file"
    end
    # Add project notes to .gitignore if not already present
    if not grep -q "^$notes_file\$" $gitignore_file
        echo $notes_file >>$gitignore_file
        echo "Added $notes_file to $gitignore_file"
    end
    # Normal session attach/create logic
    set -l session_name $argv[1]
    if test -z "$session_name"
        set session_name (basename $PWD)
    end
    # Delete dead session if it exists
    if zellij ls -n &| grep -E "^$session_name .*EXITED" >/dev/null
        echo "Cleaning up dead session: $session_name"
        zellij delete-session $session_name
    end
    # Check if session exists and attach, or create new one with layout
    if zellij ls -n &| grep -E "^$session_name " >/dev/null
        echo "Attaching to existing session: $session_name"
        zellij attach $session_name
    else
        echo "Creating new session: $session_name"
        zellij --session $session_name --new-session-with-layout session
    end
end
