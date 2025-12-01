function k8s_rollout_restart
  kubectl get deployments --all-namespaces -l=component/name -o go-template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | while read -r DEPLOYMENT
    kubectl rollout restart deployment "$DEPLOYMENT" -n "$DEPLOYMENT"
  end
end