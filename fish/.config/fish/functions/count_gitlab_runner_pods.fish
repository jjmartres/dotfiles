function count_gitlab_runner_pods
    set -l namespace gitlab-managed-apps
    set -l count (kubectl get pods -n $namespace -o name | grep runner | grep project | grep concurrent | wc -l | string trim)
    echo $count
end
