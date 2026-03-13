#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# source necessary scripts
source "docker.sh"
source "utils.sh"
source "setup-kind.sh"

# app-specific constants
DEPENDENCIES=(git docker nvm kubectl kind)

# check & install necessary dependencies
log "Checking dependencies..."
for dep in "${DEPENDENCIES[@]}"; do
        install_if_missing "$dep"
done

# main functions

# prod
# setup kubectl
kubectl_use_context "microtube"

cd ../video-streaming
docker build -t "video-streaming:1" -f "Dockerfile-prod" "."
kind load docker-image "video-streaming:1" --name "microtube"
kubectl apply -f "scripts/deploy.yml"
kubectl port-forward svc/video-streaming 30000:80 --address 0.0.0.0

# dev
# docker compose up --build

