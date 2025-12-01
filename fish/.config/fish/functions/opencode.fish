function opencode
    set default_agent build
    set config_files "opencode.json" "opencode.jsonc"
    set found_config_file ""
    set agent_name $default_agent

    for file in $config_files
        if test -f $file
            set found_config_file $file
            break
        end
    end

    if test -n "$found_config_file"
        #set agent_result (jq -r '(.agent | keys[0]) // "'$default_agent'"' $found_config_file 2>/dev/null)
        set agent_result (prettier $found_config_file | perl -0pe 's/,(\s*[}\]])/$1/g' | jq -r '(.agent | keys[0]) // "'$default_agent'"')

        if test -n "$agent_result"
            set agent_name $agent_result
        end
    end

    command opencode --agent $agent_name $argv
end
