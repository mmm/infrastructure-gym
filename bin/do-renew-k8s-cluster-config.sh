curl --request GET \
  --url https://api.digitalocean.com/v2/kubernetes/clusters/${do_k8s_cluster_id}/kubeconfig \
  --header "authorization: Bearer ${DO_TOKEN}"
