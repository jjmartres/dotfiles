function cat
    if test (count $argv) -eq 0
        return
    end

    # if file extension ends with .md or .mdx, use glow
    if string match -q "*.md" $argv
        glow $argv
    else if file --mime $argv | grep png || file --mime $argv | grep jpeg
        chafa $argv
    else if test -d $argv
        eza --icons -l $argv
    else
        bat --style=plain --theme ansi $argv
    end
end
