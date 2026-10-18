# Completions for kns (kubie ns)
complete -c kns -f

function __kns_namespaces
    if test -n "$KUBIE_ACTIVE"
        kubie ns < /dev/null 2>/dev/null
    else
        kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | string split ' '
    end
end

complete -c kns -n "not __fish_seen_subcommand_from -h --help" -a "(__kns_namespaces)" -d "Kubernetes namespace"
complete -c kns -n "not __fish_seen_subcommand_from -h --help" -a "-" -d "Switch to previous namespace"
complete -c kns -s h -l help -d "Print help"
complete -c kns -s r -l recursive -d "Enter namespace by spawning recursive shell"
complete -c kns -s u -l unset -d "Unset namespace in currently active context"
