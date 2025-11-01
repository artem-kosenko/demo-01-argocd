#!/bin/bash
set -e

echo "🚀 Installing Kubernetes on Mac (via Colima)..."

# Check Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install it manually: https://brew.sh/"
    exit 1
else
    echo "✅ Homebrew found"
fi

# Check and install Colima
if ! command -v colima &> /dev/null; then
    echo "📦 Installing Colima..."
    brew install colima
else
    echo "✅ Colima already installed"
fi

# Check and install kubectl
if ! command -v kubectl &> /dev/null; then
    echo "📦 Installing kubectl..."
    brew install kubectl
else
    echo "✅ kubectl already installed"
fi

# Check and install Helm
if ! command -v helm &> /dev/null; then
    echo "📦 Installing Helm..."
    brew install helm
else
    echo "✅ Helm already installed"
fi

# Start Colima with Kubernetes enabled
echo "🚀 Starting Colima with Kubernetes..."
colima start --cpu 4 --memory 8 --disk 20 --arch aarch64 --kubernetes

# Verify cluster status
echo "🔍 Verifying Kubernetes cluster..."
if kubectl get nodes &> /dev/null; then
    echo "✅ Kubernetes is running!"
    kubectl get nodes -o wide
else
    echo "❌ Something went wrong. Check Colima logs."
    colima status
    exit 1
fi


