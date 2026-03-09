#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# source necessary scripts
source "docker.sh"
source "utils.sh"

# app-specific constants
DEPENDENCIES=(git docker nvm kubectl)

# check & install necessary dependencies
log "Checking dependencies..."
for dep in "${DEPENDENCIES[@]}"; do
        install_if_missing "$dep"
done

# main function
docker compose up --build

