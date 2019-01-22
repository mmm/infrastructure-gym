#!/bin/bash

KUBECONFIG="${HOME}/.kube/do.yaml"
crds=(
  alertmanagers.monitoring.coreos.com
  prometheusrules.monitoring.coreos.com
  prometheuses.monitoring.coreos.com
  servicemonitors.monitoring.coreos.com
)
for crd in ${crds[@]}; do
  kubectl --kubeconfig $KUBECONFIG delete crd $crd
done
