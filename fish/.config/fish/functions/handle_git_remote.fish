function handle_git_remote
    set host (git config remote.origin.url 2>/dev/null)
    switch "$host"
        case "*gitlab*"
            glab mr list --author="$GITLAB_USER_NAME"
        case "*github*"
            gh pr list -L 3
        case "*"
            echo "Not a gitlab or github repository"
    end
end
