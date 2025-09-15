#!/bin/bash
set -e

NAMESPACE="argocd"
ARGOCD_URL="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

echo "🚀 Setting up ArgoCD in Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install it first."
    exit 1
fi

# Check if namespace exists
if kubectl get namespace "$NAMESPACE" &> /dev/null; then
    echo "✅ Namespace '$NAMESPACE' already exists"
else
    echo "📦 Creating namespace '$NAMESPACE'..."
    kubectl create namespace "$NAMESPACE"
fi

# Check if ArgoCD is already installed (by checking deployment)
if kubectl get deploy argocd-server -n "$NAMESPACE" &> /dev/null; then
    echo "✅ ArgoCD is already installed in namespace '$NAMESPACE'"
else
    echo "📦 Installing ArgoCD..."
    kubectl apply -n "$NAMESPACE" -f "$ARGOCD_URL"
fi

# Wait for ArgoCD server to become ready
echo "⏳ Waiting for ArgoCD components..."
kubectl rollout status deploy/argocd-server -n "$NAMESPACE" --timeout=180s || {
    echo "⚠️ Timeout waiting for ArgoCD server"
    exit 1
}

echo "✅ ArgoCD is installed and ready!"

# Get initial admin password if exists
if kubectl get secret argocd-initial-admin-secret -n "$NAMESPACE" &> /dev/null; then
    PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n "$NAMESPACE" -o jsonpath="{.data.password}" | base64 -d)
    echo "🔑 Initial admin password: $PASSWORD"
else
    echo "ℹ️ Initial admin password secret not found (maybe already reset)."
fi
