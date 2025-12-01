function spin
    if contains -- --help $argv
        spin $argv
    else
        rm -rf ~/.spin/config
        cp ~/.spin/config.tpl ~/.spin/config
        env ACCESS_TOKEN=(gcloud auth print-access-token) \
            REFRESH_TOKEN=(gcloud auth print-refresh-token) \
            ~/.spin/bin/spin --no-color $argv -o yaml | tail -n +2 | yq -P
    end
end
