function code --description "Pick a repository under a path with fzf and open nvim in a named zellij tab"
    # Usage: code [--refresh] <session> <path>

    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l normal (set_color normal)
    set -l bold (set_color --bold)

    # Resolve defaults from environment variables, with hard fallbacks
    set -l cache_dir (test -n "$CODE_CACHE_DIR"; and echo $CODE_CACHE_DIR; or echo "$HOME/.fish_code_function_cache")

    # Help
    if contains -- --help $argv; or contains -- -h $argv
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo "$bold code - There are many IDE, but this one is mine.         $normal"
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo ""
        echo "Usage: code [--refresh] [session] [path]"
        echo ""
        echo "$bold Arguments:$normal"
        echo "  session     Zellij session name to open the tab in"
        echo "              (default: \$CODE_DEFAULT_SESSION)"
        echo "  path        Root path to search for git repositories"
        echo "              (default: \$CODE_DEFAULT_PATH)"
        echo ""
        echo "$bold Options:$normal"
        echo "  --refresh   Force rebuild of the repository cache before opening picker"
        echo "  --rm        Delete the named session (zellij delete-session --force)"
        echo "  --resume    Reattach to an existing named session"
        echo ""
        echo "$bold Environment variables:$normal"
        echo "  CODE_CACHE_DIR        Cache directory  (current: $cache_dir)"
        echo "  CODE_DEFAULT_SESSION  Default session  (current: $CODE_DEFAULT_SESSION)"
        echo "  CODE_DEFAULT_PATH     Default path     (current: $CODE_DEFAULT_PATH)"
        echo ""
        echo "$bold Behaviour:$normal"
        echo "  • Repository list is cached in \$CODE_CACHE_DIR/<session>"
        echo "  • Cache is served instantly; a background rebuild runs after each use"
        echo "  • --refresh rebuilds the cache synchronously before showing the picker"
        echo "  • Each entry shows: basename  (git remote url)"
        echo "  • Inside Zellij: picker runs in a floating pane"
        echo "  • Outside Zellij: picker runs inline via fzf"
        echo "  • If <session> does not exist: creates it using '<session>' as layout name"
        echo "  • Tab name = repository basename; focuses existing tab or creates a new one"
        echo ""
        echo "$bold Examples:$normal"
        echo "  code                                      # uses env var defaults"
  echo "  code work ~/Repositories/work"
  echo "  code --refresh work ~/Repositories/work"
        return 0
    end

    # Parse flags
    set -l force_refresh false
    set -l force_rm false
    set -l force_resume false
    set -l positional
    for arg in $argv
        switch $arg
            case --refresh
                set force_refresh true
            case --rm
                set force_rm true
            case --resume
                set force_resume true
            case '*'
                set -a positional $arg
        end
    end

    # Apply positional args, falling back to env var defaults
    set -l session_name (test (count $positional) -ge 1; and echo $positional[1]; or echo $CODE_DEFAULT_SESSION)
    set -l search_path  (test (count $positional) -ge 2; and echo $positional[2]; or echo $CODE_DEFAULT_PATH)

    if test -z "$session_name"
        echo "$red✗ Error: session name required (pass as argument or set \$CODE_DEFAULT_SESSION)$normal"
        return 1
    end

    # --resume: reattach to an existing session and exit early
    if test "$force_resume" = true
        if zellij list-sessions -s 2>/dev/null | string match -q -- $session_name
            echo "$green→$normal Attaching to session '$bold$session_name$normal'"
            zellij attach $session_name
        else
            echo "$yellow⚠  Session '$session_name' does not exist$normal"
            return 1
        end
        return 0
    end

    # --rm: delete the session and exit early
    if test "$force_rm" = true
        if zellij list-sessions -s 2>/dev/null | string match -q -- $session_name
            echo "$red→$normal Deleting session '$bold$session_name$normal'"
            zellij delete-session $session_name --force
            echo "$green✓$normal Session '$session_name' deleted"
        else
            echo "$yellow⚠  Session '$session_name' does not exist$normal"
        end
        return 0
    end

    if test -z "$search_path"
        echo "$red✗ Error: path required (pass as argument or set \$CODE_DEFAULT_PATH)$normal"
        return 1
    end

    # Expand tilde / relative paths
    set search_path (realpath $search_path 2>/dev/null; or echo $search_path)

    if not test -d "$search_path"
        echo "$red✗ Error: path does not exist or is not a directory: $search_path$normal"
        return 1
    end

    # Cache file: one file per session name, stored under cache_dir
    mkdir -p $cache_dir
    set -l cache_file "$cache_dir/$session_name"

    # Ensure the target session exists — create it with a matching layout if not
    if not zellij list-sessions -s 2>/dev/null | string match -q -- $session_name
        set -l layout_dir ~/.config/zellij/layouts
        set -l layout default
        if test -f "$layout_dir/$session_name.kdl"
            set layout $session_name
        else
            echo "$yellow⚠  No layout '$session_name.kdl' found — falling back to 'default'$normal"
        end
        echo "$blue→$normal Creating session '$session_name' with layout '$layout'$normal"
        zellij --session $session_name --new-session-with-layout $layout 2>/dev/null &
        sleep 1
        if not zellij list-sessions -s 2>/dev/null | string match -q -- $session_name
            echo "$red✗ Error: could not create session '$session_name'$normal"
            return 1
        end
        echo "$green✓$normal Session '$session_name' created"
    end

    # Build the tab-delimited cache with three fields:
    #   field 1: parent/basename          — matched by fzf (--nth=1), never fuzzy-matches remote
    #   field 2: (remote_url)             — displayed alongside field 1 but excluded from matching
    #   field 3: full_path                — extracted via cut -f3 on select, never shown
    # Sorted alphabetically by field 1.
    # This is the slow part (fd + git remote per repo) — results are cached.
    function __code_build_cache --no-scope-shadowing
        fd --hidden --no-ignore -t d --glob '.git' --prune $search_path \
            -E '.terraform' -E 'Library' -E 'Application Support' -E '_*' \
            --exec dirname '{}' \
        | while read -l p
            set -l remote (git -C $p remote get-url origin 2>/dev/null)
            set -l bname (basename $p)
            set -l parent (basename (dirname $p))
            printf '%-40s\t(%s)\t%s\n' "$parent/$bname" $remote $p
        end | sort > $cache_file
    end

    if test "$force_refresh" = true
        echo "$blue→$normal Refreshing repository cache for $search_path …"
        __code_build_cache
        echo "$green✓$normal Cache updated ($cache_file)"
    else if not test -f "$cache_file"
        echo "$blue→$normal Building repository cache for the first time …"
        __code_build_cache
        echo "$green✓$normal Cache ready"
    end

    # After serving the picker, rebuild cache in background so next call is fresh.
    # We do this via a fish -c detached process — no output, no blocking.
    function __code_refresh_background --no-scope-shadowing
        fish -c "
            fd --hidden --no-ignore -t d --glob '.git' --prune '$search_path' \
                -E '.terraform' -E 'Library' -E 'Application Support' -E '_*' \
                --exec dirname '{}' \
            | while read -l p
                set -l remote (git -C \$p remote get-url origin 2>/dev/null)
                set -l bname (basename \$p)
                set -l parent (basename (dirname \$p))
                printf '%-40s\t(%s)\t%s\n' \"\$parent/\$bname\" \$remote \$p
            end | sort > '$cache_file'
        " &>/dev/null &
        disown
    end

    # Cache has three tab-separated fields: name\tremote\tpath
    # --nth=1      → fuzzy matching scoped to field 1 (parent/basename) only
    # --with-nth=1,2 → display fields 1 and 2 (name + remote), hide field 3 (path)
    # cut -f3 on selection extracts the full path
    set -l tab (printf '\t')
    set -l fzf_opts \
        --delimiter $tab \
        --nth=1 \
        --with-nth=1,2 \
        --prompt=" $session_name › " \
        --header="Pick a repository" \
        --preview="cd (echo {} | cut -f3); git log -n 50 --oneline --decorate --graph --color=always" \
        --preview-window="right:55%:wrap" \
        --reverse \
        --border=rounded \
        --color="header:italic:cyan,prompt:bold:green"

    set -l repo_path ""

    if set -q ZELLIJ
        # Inside Zellij: run fzf in a floating pane, write selection to tempfile
        set -l tmp_file (mktemp)

        zellij run \
            --floating \
            --close-on-exit \
            --blocking \
            --name " Pick repository" \
            -- fish -c "
                fzf $fzf_opts --height=100% < '$cache_file' \
                    | cut -f3 > '$tmp_file' 2>/dev/null
            "

        set repo_path (string trim < $tmp_file)
        rm -f $tmp_file
    else
        # Outside Zellij: fzf uses /dev/tty directly
        set repo_path (fzf $fzf_opts --height=80% < $cache_file \
            | cut -f3)
    end

    # Kick off background cache refresh (fire-and-forget)
    __code_refresh_background

    if test -z "$repo_path"
        echo "$yellow⚠  No repository selected$normal"
        return 0
    end

    set -l repo_name (basename $repo_path)
    set -l tab_name "󰆦 $repo_name"

    echo "$cyan→$normal Session:    $bold$session_name$normal"
    echo "$cyan→$normal Repository: $bold$repo_name$normal"
    echo "$cyan→$normal Path:       $repo_path"

    # Check whether the tab already exists in the target session
    set -l existing_tab (env ZELLIJ_SESSION_NAME=$session_name zellij action list-tabs -j 2>/dev/null \
        | jq -r '.[].name' 2>/dev/null \
        | string match -e -- $tab_name)

    if test -n "$existing_tab"
        echo "$green✓$normal Tab '$tab_name' already exists — focusing it"
        env ZELLIJ_SESSION_NAME=$session_name zellij action go-to-tab-name $tab_name
    else
        echo "$blue→$normal Creating new tab '$tab_name' with nvim"
        env ZELLIJ_SESSION_NAME=$session_name \
            zellij action new-tab \
            --name $tab_name \
            --cwd $repo_path \
            -- nvim .

        # Move the new tab to position 0 (before k8s).
        # It lands at the last position; query its index then move left that many times.
        set -l tab_pos (env ZELLIJ_SESSION_NAME=$session_name zellij action list-tabs -j 2>/dev/null \
            | jq -r ".[] | select(.name == \"$tab_name\") | .position")

        for i in (seq 1 $tab_pos)
            env ZELLIJ_SESSION_NAME=$session_name zellij action move-tab left
        end
    end

    # If called from outside Zellij, attach to the session so the user lands in it
    if not set -q ZELLIJ
        zellij attach $session_name
    end
end
