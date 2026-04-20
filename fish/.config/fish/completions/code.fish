# Completions for the code function

# Helpers
function __code_sessions
    zellij list-sessions -s 2>/dev/null
end

function __code_layouts
    # Layout names from ~/.config/zellij/layouts/*.kdl, without extension
    for f in ~/.config/zellij/layouts/*.kdl
        basename $f .kdl
    end
end

function __code_session_candidates
    # Union of running sessions and available layouts, deduplicated
    begin
        __code_sessions
        __code_layouts
    end | sort -u
end

function __code_has_flag
    contains -- $argv[1] (commandline -opc)
end

function __code_positional_count
    # Count non-flag tokens after "code" in the current commandline
    set -l tokens (commandline -opc)
    set -l count 0
    for t in $tokens[2..]   # skip "code" itself
        if not string match -q -- '--*' $t
            set count (math $count + 1)
        end
    end
    echo $count
end

# Disable default file completion
complete -c code -f

# ── Flags ──────────────────────────────────────────────────────────────────────

complete -c code -l help    -s h -d "Show help message"
complete -c code -l refresh          -d "Force rebuild of the repository cache" \
    -n "not __code_has_flag --rm"
complete -c code -l rm               -d "Delete the named Zellij session" \
    -n "not __code_has_flag --refresh"

# ── Positional arg 1: session name ────────────────────────────────────────────
# Suggest running sessions + available layouts when no positional arg given yet

complete -c code \
    -n "test (__code_positional_count) -eq 0" \
    -a "(__code_session_candidates)" \
    -d "Zellij session"

# ── Positional arg 2: search path ─────────────────────────────────────────────
# Only relevant without --rm; re-enable directory completion for this arg

complete -c code -F \
    -n "test (__code_positional_count) -eq 1; and not __code_has_flag --rm"
