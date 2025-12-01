function k8s_pending_pods
    for cluster in (kctx)
        kctx $cluster
        set pending_count (kubectl get pods -A --field-selector=status.phase=Pending --no-headers 2>/dev/null | wc -l 2>&1 )
        echo "Total pending pods in cluster $cluster: $pending_count"
    end
end
