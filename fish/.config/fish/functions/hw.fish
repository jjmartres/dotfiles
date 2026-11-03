function hw --description "Launch or attach a Herdr workspace with agent (fw), vim, and terminal tabs"
    # Usage: hw [--help] [-p|--pick] [path | name path]

    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l red (set_color red)
    set -l cyan (set_color cyan)
    set -l normal (set_color normal)
    set -l bold (set_color --bold)

    # Help
    if contains -- --help $argv; or contains -- -h $argv
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo "$bold hw - Herdr Workspace (Agent fw + Vim + Terminal)          $normal"
        echo "$bold$cyan━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$normal"
        echo ""
        echo "Usage: hw [path]"
        echo "       hw [name] [path]"
        echo "       hw -p | --pick"
        echo ""
        echo "$bold Arguments:$normal"
        echo "  path        Directory or git repository to open (default: current directory)"
        echo "  name        Workspace label/name (default: repo or directory name)"
        echo ""
        echo "$bold Options:$normal"
        echo "  -p, --pick  Pick a repository interactively via fzf"
        echo "  -h, --help  Show this help message"
        echo ""
        echo "$bold Behaviour:$normal"
        echo "  • Ensures the Herdr server is running"
        echo "  • Creates a dedicated workspace with 3 tabs:"
        echo "      1. 󱚣 fw        — Launches your agent (fw)"
        echo "      2.  vim       — Launches editor (nvim/vim)"
        echo "      3.  terminal  — Interactive shell in project cwd"
        echo "  • If workspace already exists, switches focus to it"
        echo "  • Inside Herdr: focuses the workspace directly"
        echo "  • Outside Herdr: attaches to Herdr"
        return 0
    end

    # Parse flags and arguments
    set -l pick_repo false
    set -l positional

    for arg in $argv
        switch $arg
            case -p --pick
                set pick_repo true
            case '-*'
                echo "$red✗ Error: Unknown flag $arg$normal"
                return 1
            case '*'
                set -a positional $arg
        end
    end

    set -l ws_name ""
    set -l target_path ""

    if test "$pick_repo" = true
        set -l cache_dir (test -n "$CODE_CACHE_DIR"; and echo $CODE_CACHE_DIR; or echo "$HOME/.fish_code_function_cache")
        set -l session_name (test -n "$CODE_DEFAULT_SESSION"; and echo $CODE_DEFAULT_SESSION; or echo "repositories")
        set -l cache_file "$cache_dir/$session_name"

        if not test -f "$cache_file"
            echo "$red✗ Error: Repository cache not found ($cache_file). Run 'code --refresh' first.$normal"
            return 1
        end

        set -l tab_char (printf '\t')
        set -l fzf_opts \
            --delimiter $tab_char \
            --nth=1 \
            --with-nth=1,2 \
            --prompt=" hw › " \
            --header="Pick a repository" \
            --preview="cd (echo {} | cut -f3); git log -n 50 --oneline --decorate --graph --color=always" \
            --preview-window="right:55%:wrap" \
            --reverse \
            --border=rounded \
            --color="header:italic:cyan,prompt:bold:green"

        set -l selected_path (fzf $fzf_opts --height=80% < $cache_file | cut -f3)
        if test -z "$selected_path"
            echo "$yellow⚠ No repository selected$normal"
            return 0
        end

        set target_path $selected_path
        set ws_name (basename $target_path)
    else
        switch (count $positional)
            case 0
                set target_path $PWD
                set -l git_root (git -C $target_path rev-parse --show-toplevel 2>/dev/null)
                if test -n "$git_root"
                    set target_path $git_root
                end
                set ws_name (basename $target_path)
            case 1
                set target_path (realpath $positional[1] 2>/dev/null; or echo $positional[1])
                set -l git_root (git -C $target_path rev-parse --show-toplevel 2>/dev/null)
                if test -n "$git_root"
                    set target_path $git_root
                end
                set ws_name (basename $target_path)
            case 2
                set ws_name $positional[1]
                set target_path (realpath $positional[2] 2>/dev/null; or echo $positional[2])
            case '*'
                echo "$red✗ Error: Too many arguments$normal"
                return 1
        end
    end

    if not test -d "$target_path"
        echo "$red✗ Error: Directory does not exist: $target_path$normal"
        return 1
    end

    # Verify herdr binary is available
    if not command -q herdr
        echo "$red✗ Error: herdr binary not found in PATH$normal"
        return 1
    end

    # Ensure Herdr server is running
    set -l is_inside_herdr false
    if test "$HERDR_ENV" = 1
        set is_inside_herdr true
    end

    if test "$is_inside_herdr" = false
        set -l server_running false
        if herdr status 2>/dev/null | string match -q "*status: running*"
            set server_running true
        end

        if test "$server_running" = false
            echo "$blue→$normal Starting Herdr server in background …"
            herdr server &>/dev/null &
            disown

            set -l retries 25
            while test $retries -gt 0
                if herdr status 2>/dev/null | string match -q "*status: running*"
                    set server_running true
                    break
                end
                sleep 0.1
                set retries (math $retries - 1)
            end

            if test "$server_running" = false
                echo "$red✗ Error: Failed to start Herdr server$normal"
                return 1
            end
            echo "$green✓$normal Herdr server ready"
        end
    end

    # Check if workspace with this label already exists
    set -l existing_ws_id (herdr workspace list 2>/dev/null | jq -r --arg name "$ws_name" '.result.workspaces[]? | select(.label == $name) | .workspace_id' | head -n1)

    if test -n "$existing_ws_id"
        echo "$green→$normal Workspace '$bold$ws_name$normal' already exists ($existing_ws_id) — switching focus"
        herdr workspace focus "$existing_ws_id" >/dev/null 2>&1

        if test "$is_inside_herdr" = false
            exec herdr
        end
        return 0
    end

    # Create new workspace
    echo "$cyan→$normal Creating workspace '$bold$ws_name$normal' in $target_path …"
    set -l ws_res (herdr workspace create --label "$ws_name" --cwd "$target_path" 2>/dev/null)
    set -l ws_id (echo $ws_res | jq -r '.result.workspace.workspace_id // empty')
    set -l tab1_id (echo $ws_res | jq -r '.result.tab.tab_id // empty')
    set -l pane1_id (echo $ws_res | jq -r '.result.root_pane.pane_id // empty')

    if test -z "$ws_id"
        echo "$red✗ Error: Failed to create Herdr workspace$normal"
        return 1
    end

    # Tab 1: Agent (fw)
    echo "$blue→$normal Setting up Tab 1: $bold󱚣 fw$normal"
    herdr tab rename "$tab1_id" "󱚣 fw" >/dev/null 2>&1
    herdr pane report-metadata "$pane1_id" --source fw --display-agent "fw" >/dev/null 2>&1
    herdr pane run "$pane1_id" "fw" >/dev/null 2>&1
    # Give Herdr a moment to detect and name the live agent
    herdr agent rename "$pane1_id" "fw" >/dev/null 2>&1 &

    # Tab 2: Editor (nvim or vim)
    echo "$blue→$normal Setting up Tab 2: $bold vim$normal"
    set -l tab2_res (herdr tab create --workspace "$ws_id" --label " vim" --cwd "$target_path" 2>/dev/null)
    set -l pane2_id (echo $tab2_res | jq -r '.result.root_pane.pane_id // empty')

    set -l editor_cmd "nvim ."
    if not command -q nvim
        set editor_cmd "vim ."
    end
    if test -n "$pane2_id"
        herdr pane run "$pane2_id" "$editor_cmd" >/dev/null 2>&1
    end

    # Tab 3: Terminal
    echo "$blue→$normal Setting up Tab 3: $bold terminal$normal"
    herdr tab create --workspace "$ws_id" --label " terminal" --cwd "$target_path" >/dev/null 2>&1

    # Focus initial tab (Tab 1: agent) and workspace
    herdr tab focus "$tab1_id" >/dev/null 2>&1
    herdr workspace focus "$ws_id" >/dev/null 2>&1

    echo "$green✓$normal Workspace '$bold$ws_name$normal' initialized successfully"

    # Attach to Herdr if outside
    if test "$is_inside_herdr" = false
        exec herdr
    end

    return 0
end
