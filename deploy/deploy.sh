#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:-docker.io/siddhant9960/order-management:latest}"
NAMESPACE="${2:-default}"
# Create namespace if missing
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"
# Replace placeholder image in deployment manifest and apply
TMPFILE=$(mktemp)
sed "s|IMAGE_PLACEHOLDER|${IMAGE}|g" k8s/deployment.yaml > "$TMPFILE"
kubectl apply -n "$NAMESPACE" -f "$TMPFILE"
rm "$TMPFILE"
# Apply other manifests
kubectl apply -n "$NAMESPACE" -f k8s/service.yaml
kubectl apply -n "$NAMESPACE" -f k8s/configmap.yaml
kubectl apply -n "$NAMESPACE" -f k8s/secret.yaml
kubectl apply -n "$NAMESPACE" -f k8s/ingress-tls.yaml || true
kubectl apply -n "$NAMESPACE" -f k8s/hpa.yaml || true

echo "Deployed image: $IMAGE to namespace: $NAMESPACE"
