#!/bin/bash
set -euo pipefail

kubectl_use_context(){
	local cluster="$1"
	if ! kubectl config use-context kind-"${cluster}" >/dev/null 2>&1; then
		echo "Cluster ${cluster} NOT found. Creating..."
		kind create cluster --name "${cluster}"
	fi
	kubectl config use-context kind-"${cluster}"
}

