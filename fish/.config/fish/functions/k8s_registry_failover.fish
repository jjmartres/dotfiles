function k8s_registry_failover --description "Execute Artifact Registry failover commands from K8s ConfigMap"
    set -l namespace ops-managed-apps
    set -l configmap registry-failover-scripts
    set -l action $argv[1]

    switch "$action"
        case info
            echo (set_color cyan)"--- Reading Failover Documentation ---"(set_color normal)
            kubectl get cm $configmap -n $namespace -o jsonpath='{.data.README\.md}' | glow --pager

        case test
            echo (set_color yellow)"--- Executing DRY RUN ---"(set_color normal)
            # Fish uses 'bash -c' or piping into bash to execute bash scripts safely
            kubectl get cm $configmap -n $namespace -o jsonpath='{.data.failover\.sh}' | bash -s -- --dry-run

        case apply
            echo (set_color --bold red)"🚨 WARNING: Executing LIVE Failover 🚨"(set_color normal)

            # Fish confirmation prompt
            read -l -P "Are you sure you want to proceed? [y/N] " confirm
            if test "$confirm" = y -o "$confirm" = Y
                kubectl get cm $configmap -n $namespace -o jsonpath='{.data.failover\.sh}' | bash
            else
                echo "Operation cancelled."
            end

        case '*'
            echo "Usage: k8s_registry_failure {info|test|apply}"
            return 1
    end
end
