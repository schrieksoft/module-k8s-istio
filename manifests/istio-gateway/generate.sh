#!/bin/bash

HELM_CHART_VERSION="1.22.0"
NAMESPACE="istio-gateway"

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
helm template istio-gateway istio/gateway --version "$HELM_CHART_VERSION" --namespace "$NAMESPACE" --values values/public-values.yaml > generated-public.yaml
# helm template istio-gateway-private istio/gateway --version "$HELM_CHART_VERSION" --namespace "$NAMESPACE" --values values/private-values.yaml > generated-private.yaml
# helm template istio-gateway-daemon-set istio/gateway --version "$HELM_CHART_VERSION" --namespace "$NAMESPACE" --values values/daemon-set-values.yaml > generated-daemon-set.yaml # read https://istio.io/latest/docs/tasks/security/authorization/authz-ingress/#network
