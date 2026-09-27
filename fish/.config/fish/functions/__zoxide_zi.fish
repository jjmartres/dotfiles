function __zoxide_zi --description "Interactive zoxide search with ~ for home directory"
    set -l tmp (mktemp)
    command zoxide query --exclude (__zoxide_pwd) -l 2>/dev/null | string replace "$HOME" "~" > $tmp
    set -l result
    if test -s $tmp
        set -l fzf_query (string join " " $argv)
        set -l fzf_extra
        if set -q _ZO_FZF_OPTS
            set fzf_extra (string match -ra '\S+' -- $_ZO_FZF_OPTS)
        end
        set result (fzf $fzf_extra --query="$fzf_query" < $tmp)
    end
    rm -f $tmp
    if test -n "$result"
        set -l path (string replace "~" "$HOME" -- $result)
        __zoxide_cd $path
    end
end
