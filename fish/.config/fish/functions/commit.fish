function commit
    $HOMEBREW_PREFIX/bin/opencode run \
        --agent build \
        -- model google-vertex/gemini-2.5-pro \
        /commit
    git push \
        -o merge_request.create \
        -o merge_request.target=$(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))
end
