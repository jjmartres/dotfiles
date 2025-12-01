function check_spinnaker_deployments
    set -l context fte-cicd-b-gke-euno1-c1-66a1
    set -l namespace spinnaker

    set -l not_ready_pods (kubectl get pods -n $namespace --context $context | awk 'NR>1 {split($2, ready, "/"); if (ready[1] != ready[2]) print $1}')

    if test -n "$not_ready_pods"
        echo "KO"
        echo "The following pods are not ready:"
        echo $not_ready_pods
    else
        echo "OK"
    end
end
