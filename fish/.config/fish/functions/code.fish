function code --description "Pick a repository under a path with fzf and open nvim in project directory"
    # Usage: code [--refresh] [path]

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
        echo "Usage: code [--refresh] [path]"
        echo ""
        echo "$bold Arguments:$normal"
        echo "  path        Root path to search for git repositories"
        echo "              (default: \$CODE_DEFAULT_PATH)"
        echo ""
        echo "$bold Options:$normal"
        echo "  --refresh   Force rebuild of the repository cache before opening picker"
        echo ""
        echo "$bold Environment variables:$normal"
        echo "  CODE_CACHE_DIR        Cache directory  (current: $cache_dir)"
        echo "  CODE_DEFAULT_PATH     Default path     (current: $CODE_DEFAULT_PATH)"
        echo "  CODE_DEFAULT_SESSION  Cache file name  (current: $CODE_DEFAULT_SESSION)"
        echo ""
        echo "$bold Behaviour:$normal"
        echo "  • Repository list is cached in \$CODE_CACHE_DIR/\$CODE_DEFAULT_SESSION"
        echo "  • Cache is served instantly; a background rebuild runs after each use"
        echo "  • --refresh rebuilds the cache synchronously before showing the picker"
        echo "  • Each entry shows: parent/basename  (git remote url)"
        echo "  • Picker runs inline via fzf with git log preview"
        echo "  • Opens selected repository in Neovim"
        echo ""
        echo "$bold Examples:$normal"
        echo "  code                              # uses \$CODE_DEFAULT_PATH"
        echo "  code ~/Repositories/work          # search specific path"
        echo "  code --refresh ~/Repositories     # rebuild cache then pick"
        return 0
    end

    # Parse flags
    set -l force_refresh false
    set -l positional
    for arg in $argv
        switch $arg
            case --refresh
                set force_refresh true
            case '*'
                set -a positional $arg
        end
    end

    # Apply positional args, falling back to env var defaults
    set -l search_path (test (count $positional) -ge 1; and echo $positional[1]; or echo $CODE_DEFAULT_PATH)

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

    # Cache files: named by CODE_DEFAULT_SESSION, falling back to "repositories"
    #   $cache_file      — tab-delimited (name\tremote\tpath), read by fzf
    #   $cache_file.nvim — one absolute path per line, read by Neovim via NVIM_PROJECTS_FILE
    mkdir -p $cache_dir
    set -l session_name (test -n "$CODE_DEFAULT_SESSION"; and echo $CODE_DEFAULT_SESSION; or echo "repositories")
    set -l cache_file "$cache_dir/$session_name"
    set -l nvim_cache_file "$cache_file.nvim"

    # Build the tab-delimited cache with three fields:
    #   field 1: parent/basename          — matched by fzf (--nth=1), never fuzzy-matches remote
    #   field 2: (remote_url)             — displayed alongside field 1 but excluded from matching
    #   field 3: full_path                — extracted via cut -f3 on select, never shown
    # Sorted alphabetically by field 1.
    # Also writes $cache_file.nvim: field 3 (full path) only, one per line, for Neovim.
    # This is the slow part (fd + git remote per repo) — results are cached.
    function __code_build_cache --no-scope-shadowing
        fd --hidden --no-ignore -t d --glob '.git' --prune $search_path \
            -E '.terraform' -E Library -E 'Application Support' -E '_*' \
            --exec dirname '{}' \
            | while read -l p
            set -l remote (git -C $p remote get-url origin 2>/dev/null)
            set -l bname (basename $p)
            set -l parent (basename (dirname $p))
            printf '%-40s\t(%s)\t%s\n' "$parent/$bname" $remote $p
        end | sort >$cache_file
        cut -f3 $cache_file >$nvim_cache_file
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

    # After serving the picker, rebuild both cache files in background so next call is fresh.
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
            cut -f3 '$cache_file' > '$nvim_cache_file'
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
        --prompt=" code › " \
        --header="Pick a repository" \
        --preview="cd (echo {} | cut -f3); git log -n 50 --oneline --decorate --graph --color=always" \
        --preview-window="right:55%:wrap" \
        --reverse \
        --border=rounded \
        --color="header:italic:cyan,prompt:bold:green"

    # Run fzf picker
    set -l repo_path (fzf $fzf_opts --height=80% < $cache_file | cut -f3)

    # Kick off background cache refresh (fire-and-forget)
    __code_refresh_background

    if test -z "$repo_path"
        echo "$yellow⚠  No repository selected$normal"
        return 0
    end

    set -l repo_name (basename $repo_path)

    echo "$cyan→$normal Repository: $bold$repo_name$normal"
    echo "$cyan→$normal Path:       $repo_path"

    # Check for backgrounded nvim instance (any nvim job that's stopped)
    set -l nvim_job (jobs -c | string match -r '^\d+.*nvim' | string match -r '^\d+' | head -n1)

    if test -n "$nvim_job"
        echo "$green→$normal Found backgrounded Neovim (job $nvim_job) — bringing to foreground"
        fg %$nvim_job
    else if set -q GHOSTTY_RESOURCES_DIR
        # Inside Ghostty: check if a tab for this repo already exists
        set -l existing_tabs (osascript -e 'tell application "Ghostty" to get name of tabs of window 1' 2>/dev/null)

        # Check if any tab contains this repo name (match pattern: "󰬊 repo-name (branch:")
        set -l tab_exists false
        set -l tab_index 1

        if test -n "$existing_tabs"
            for tab_name in (string split ',' -- $existing_tabs)
                set tab_name (string trim -- $tab_name)
                # Match if tab name starts with "󰬊 $repo_name ("
                if string match -q "󰬊 $repo_name (*" -- $tab_name
                    set tab_exists true
                    break
                end
                set tab_index (math $tab_index + 1)
            end
        end

        if test "$tab_exists" = true
            echo "$green→$normal Tab for '$bold$repo_name$normal' already exists — switching to tab $tab_index"
            # Use Cmd+<number> to switch to the tab (Cmd+1 for first tab, etc.)
            osascript -e "tell application \"System Events\" to tell process \"ghostty\"
                keystroke \"$tab_index\" using command down
            end tell" 2>/dev/null
        else
            # No existing tab: create a new one
            echo "$green→$normal Opening in new Ghostty tab"

            # Save current clipboard
            set -l saved_clipboard (pbpaste)

            # Build the full command with dynamic title setting using Fish syntax
            # Clear the screen first to hide the pasted command, then execute
            # After nvim exits (quit or background), exit the shell to close the tab
            # Format: 󰬊 basename (branch: branch-name, head: commit-hash)
            set -l title_cmd 'set -l branch (git branch --show-current 2>/dev/null; or echo "detached"); set -l commit (git rev-parse --short HEAD 2>/dev/null; or echo "no-commit"); printf "\\e]2;󰬊 %s (branch: %s, head: %s)\\a" "'"$repo_name"'" $branch $commit'
            set -l full_cmd "clear; cd $repo_path; and $title_cmd; and nvim .; exit"

            # Copy command to clipboard
            printf '%s' $full_cmd | pbcopy

            # Send Cmd+T to create new tab, paste command, and execute
            osascript -e 'tell application "System Events" to tell process "ghostty"
                keystroke "t" using command down
                delay 0.2
                keystroke "v" using command down
                delay 0.1
                keystroke return
            end tell' 2>/dev/null

            # Restore clipboard after a short delay
            fish -c "sleep 0.5; printf '%s' (string escape -- '$saved_clipboard') | pbcopy" &>/dev/null &
            disown
        end
    else
        # Not in Ghostty: open nvim in current terminal
        echo "$green→$normal Opening in Neovim"
        cd $repo_path; and nvim .
    end
end
