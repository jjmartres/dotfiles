# Completions for kubie
complete -c kubie -e
complete -c kubie -f

function __kubie_contexts
    kubie ctx < /dev/null 2>/dev/null
end

function __kubie_namespaces
    if test -n "$KUBIE_ACTIVE"
        kubie ns < /dev/null 2>/dev/null
    else
        kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | string split ' '
    end
end

# Commands
complete -c kubie -n "__fish_use_subcommand" -a ctx -d "Spawn shell in given context"
complete -c kubie -n "__fish_use_subcommand" -a ns -d "Change namespace in current shell"
complete -c kubie -n "__fish_use_subcommand" -a info -d "View info about current kubie shell"
complete -c kubie -n "__fish_use_subcommand" -a exec -d "Execute command inside context and namespace"
complete -c kubie -n "__fish_use_subcommand" -a export -d "Print path to isolated config file"
complete -c kubie -n "__fish_use_subcommand" -a edit -d "Edit context config file"
complete -c kubie -n "__fish_use_subcommand" -a edit-config -d "Edit kubie config file"
complete -c kubie -n "__fish_use_subcommand" -a lint -d "Lint k8s config files"
complete -c kubie -n "__fish_use_subcommand" -a update -d "Check for kubie update"
complete -c kubie -n "__fish_use_subcommand" -a delete -d "Delete context"

# ctx
complete -c kubie -n "__fish_seen_subcommand_from ctx; and not __fish_seen_subcommand_from -h --help" -a "(__kubie_contexts)" -d "Kubernetes context"
complete -c kubie -n "__fish_seen_subcommand_from ctx; and not __fish_seen_subcommand_from -h --help" -a "-" -d "Switch to previous context"
complete -c kubie -n "__fish_seen_subcommand_from ctx" -s n -l namespace -d "Specify namespace" -r -f -a "(__kubie_namespaces)"
complete -c kubie -n "__fish_seen_subcommand_from ctx" -s r -l recursive -d "Spawn recursive shell"
complete -c kubie -n "__fish_seen_subcommand_from ctx" -s f -l kubeconfig -d "Kubeconfig files" -r -F

# ns
complete -c kubie -n "__fish_seen_subcommand_from ns; and not __fish_seen_subcommand_from -h --help" -a "(__kubie_namespaces)" -d "Kubernetes namespace"
complete -c kubie -n "__fish_seen_subcommand_from ns; and not __fish_seen_subcommand_from -h --help" -a "-" -d "Switch to previous namespace"
complete -c kubie -n "__fish_seen_subcommand_from ns" -s r -l recursive -d "Spawn recursive shell"
complete -c kubie -n "__fish_seen_subcommand_from ns" -s u -l unset -d "Unset namespace"

# info
complete -c kubie -n "__fish_seen_subcommand_from info" -a "ctx ns depth"

# exec & export
complete -c kubie -n "__fish_seen_subcommand_from exec export; and test (count (commandline -opc)) -eq 2" -a "(__kubie_contexts)" -d "Kubernetes context"
complete -c kubie -n "__fish_seen_subcommand_from exec export; and test (count (commandline -opc)) -eq 3" -a "(__kubie_namespaces)" -d "Kubernetes namespace"
