#!/bin/bash
# Copyright (c) 2020 Red Hat, Inc.

if [ -z ${ACM_NAMESPACE+x} ]; 
then 
    echo "ACM_NAMESPACE must be set"
    exit 1
else 
    echo "Cleaning up resources in namespace: $ACM_NAMESPACE"
fi


oc delete mch --all -n $ACM_NAMESPACE

## Delete all helm charts in given namespace
helm ls --namespace $ACM_NAMESPACE | cut -f 1 | tail -n +2 | xargs -n 1 helm delete --namespace $ACM_NAMESPACE

oc delete apiservice v1.admission.cluster.open-cluster-management.io v1beta1.webhook.certmanager.k8s.io
oc delete clusterimageset --all
oc delete configmap -n $ACM_NAMESPACE cert-manager-controller cert-manager-cainjector-leader-election cert-manager-cainjector-leader-election-core
oc delete consolelink acm-console-link
oc delete crd klusterletaddonconfigs.agent.open-cluster-management.io placementbindings.policy.open-cluster-management.io policies.policy.open-cluster-management.io userpreferences.console.open-cluster-management.io
oc delete mutatingwebhookconfiguration cert-manager-webhook
oc delete oauthclient multicloudingress
oc delete rolebinding -n kube-system cert-manager-webhook-webhook-authentication-reader
oc delete scc kui-proxy-scc
oc delete validatingwebhookconfiguration cert-manager-webhook