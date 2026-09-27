function zoc --description "Navigate to a directory with zoxide and launch opencode"
    set -l target

    if test (count $argv) -eq 0
        # No arguments: interactive selection
        set -l tmp (mktemp)
        command zoxide query --exclude (__zoxide_pwd) -l 2>/dev/null | string replace "$HOME" "~" > $tmp
        if test -s $tmp
            set -l fzf_extra
            if set -q _ZO_FZF_OPTS
                set fzf_extra (string match -ra '\S+' -- $_ZO_FZF_OPTS)
            end
            set target (fzf $fzf_extra < $tmp)
        end
        rm -f $tmp
    else if test (count $argv) -eq 1 -a -d (string replace "~" "$HOME" -- $argv[1])
        # Direct existing directory path passed
        set target (string replace "~" "$HOME" -- $argv[1])
    else
        # Try zoxide query first
        set target (command zoxide query --exclude (__zoxide_pwd) -- $argv 2>/dev/null)
        if test -z "$target"
            # Fallback to interactive fzf with the query pre-filled
            set -l tmp (mktemp)
            command zoxide query --exclude (__zoxide_pwd) -l 2>/dev/null | string replace "$HOME" "~" > $tmp
            if test -s $tmp
                set -l fzf_query (string join " " $argv)
                set -l fzf_extra
                if set -q _ZO_FZF_OPTS
                    set fzf_extra (string match -ra '\S+' -- $_ZO_FZF_OPTS)
                end
                set target (fzf $fzf_extra --query="$fzf_query" < $tmp)
            end
            rm -f $tmp
        end
    end

    if test -z "$target"
        return 0
    end

    set target (string replace "~" "$HOME" -- $target)

    if test -d "$target"
        cd "$target"
        and command zoxide add -- "$target"
        and opencode
    else
        echo (set_color red)"✗ Directory not found: $target"(set_color normal)
        return 1
    end
end
