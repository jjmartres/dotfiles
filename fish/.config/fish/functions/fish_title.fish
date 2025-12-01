function fish_title
    set -l title_parts

    if fish_is_root_user # .Root (Standard Fish way to check root)
        set title_parts Root
    end

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1 # .Segments.Git.RepoName (Standard Git check)
        set -l repo_name (basename (git rev-parse --show-toplevel 2>/dev/null))
        set -l head (git rev-parse --short HEAD 2>/dev/null)
        set -l branch_name (git rev-parse --abbrev-ref HEAD)
        if test -n "$title_parts"
            set title_parts "$title_parts@"
        end
        set title_parts "$title_parts $repo_name (branch: $branch_name, head: $head)"
    else # else of or .Root .Segments.Git.RepoName
        if test "$PWD" = "$HOME"
            set title_parts "~" # Show ~ if in home directory
        else
            set title_parts "$PWD" # .Folder (Fish native PWD)
        end
    end

    echo $title_parts

end
