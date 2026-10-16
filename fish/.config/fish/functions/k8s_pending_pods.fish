function k8s_pending_pods --description "Check pending pods across all Kubernetes contexts"
    set -l clusters (kubie ctx < /dev/null 2>/dev/null)
    if test (count $clusters) -eq 0
        set clusters (kubectl config get-contexts -o name 2>/dev/null)
    end

    for cluster in $clusters
        set -l pending_count (kubectl --context $cluster get pods -A --field-selector=status.phase=Pending --no-headers 2>/dev/null | wc -l 2>&1 | string trim)
        echo "Total pending pods in cluster $cluster: $pending_count"
    end
end
