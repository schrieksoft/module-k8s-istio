#!/bin/bash

HELM_CHART_VERSION="1.22.0"
NAMESPACE="istio-gateway-private"

helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
helm template istio-gateway-private istio/gateway --version "$HELM_CHART_VERSION" --namespace "$NAMESPACE" --values values/private-values.yaml > generated-private.yaml
