function tab --description "Pick a Zellij tab with fzf and switch to it"
    if not set -q ZELLIJ
        echo "Not inside a Zellij session" >&2
        return 1
    end

    set -l tab_name (zellij action list-tabs -j 2>/dev/null \
        | jq -r '.[] | "\(.position)\t\(.name)"' \
        | fzf \
            --delimiter="\t" \
            --with-nth=2 \
            --prompt=" tab › " \
            --header="Switch to tab" \
            --reverse \
            --border=rounded \
            --color="header:italic:cyan,prompt:bold:green" \
            --height=50% \
        | cut -f2)

    if test -n "$tab_name"
        zellij action go-to-tab-name $tab_name
    end
end
