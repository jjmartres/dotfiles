# Completions for kctx (kubie ctx)
complete -c kctx -f

function __kctx_contexts
    kubie ctx < /dev/null 2>/dev/null
end

function __kctx_namespaces
    if test -n "$KUBIE_ACTIVE"
        kubie ns < /dev/null 2>/dev/null
    else
        kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | string split ' '
    end
end

complete -c kctx -n "not __fish_seen_subcommand_from -h --help" -a "(__kctx_contexts)" -d "Kubernetes context"
complete -c kctx -n "not __fish_seen_subcommand_from -h --help" -a "-" -d "Switch to previous context"
complete -c kctx -s h -l help -d "Print help"
complete -c kctx -s r -l recursive -d "Enter context by spawning recursive shell"
complete -c kctx -s n -l namespace -d "Specify namespace in which shell is spawned" -r -f -a "(__kctx_namespaces)"
complete -c kctx -s f -l kubeconfig -d "Specify files from which to load contexts" -r -F
