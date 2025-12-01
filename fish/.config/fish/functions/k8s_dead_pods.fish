function k8s_dead_pods
    kubectl get pods --all-namespaces | grep -E 'OutOfcpu|OOMKilled' | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
end
