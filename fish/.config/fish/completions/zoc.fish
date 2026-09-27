# Completions for zoc function

function __zoc_complete
    set -l tokens (builtin commandline --current-process --tokenize)
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
        builtin commandline --replace -- "zoc "(string escape -- $path)
        builtin commandline --function repaint execute
    end
end

complete -c zoc -f
complete -c zoc -a '(__zoc_complete)'
