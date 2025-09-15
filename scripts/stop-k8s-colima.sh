#!/bin/bash
set -e

echo "🛑 Stopping Kubernetes cluster (Colima)..."

# Check if Colima is installed
if ! command -v colima &> /dev/null; then
    echo "❌ Colima is not installed. Nothing to stop."
    exit 0
fi

# Check if Colima is running
if colima list | grep -q "Running"; then
    echo "📦 Colima is running. Stopping it..."
    colima stop
    echo "✅ Colima stopped. Kubernetes cluster preserved."
else
    echo "ℹ️ Colima is already stopped."
fi
