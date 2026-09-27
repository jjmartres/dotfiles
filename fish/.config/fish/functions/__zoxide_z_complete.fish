function __zoxide_z_complete --description "Interactive z completion with ~ for home directory"
    set -l tokens (builtin commandline --current-process --tokenize)
    set -l curr_tokens (builtin commandline --cut-at-cursor --current-process --tokenize)

    if test (builtin count $tokens) -le 2 -a (builtin count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(builtin commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (builtin count $tokens) -eq (builtin count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]
        set -l tmp (mktemp)
        command zoxide query --exclude (__zoxide_pwd) -l 2>/dev/null | string replace "$HOME" "~" > $tmp
        set -l result
        if test -s $tmp
            set -l fzf_query (string join " " $query)
            set -l fzf_extra
            if set -q _ZO_FZF_OPTS
                set fzf_extra (string match -ra '\S+' -- $_ZO_FZF_OPTS)
            end
            set result (fzf $fzf_extra --query="$fzf_query" < $tmp)
        end
        rm -f $tmp
        if test -n "$result"
            set -l path (string replace "~" "$HOME" -- $result)
            builtin commandline --replace -- "z "(string escape -- $path)
            builtin commandline --function repaint execute
        end
    end
end
