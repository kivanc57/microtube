#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

APP_TAG="microtube:latest"
REGISTRY_APP_TAG="${APP_TAG}"
DEPENDENCIES=(git docker nvm)

source ".env"
source "${SCRIPT_DIR}/dependencies/install-utils.sh"

PORT="${PORT:-3000}"
: "${REGISTRY_URL:?REGISTRY_URL not set}"
: "${REGISTRY_USERNAME:?REGISTRY_USERNAME not set}"
: "${REGISTRY_PASSWORD:?REGISTRY_PASSWORD not set}"

# set logger func
log() { printf '\n[%s] %s\n' "$(date -Is)" "$*"; }

# check & install necessary dependencies
log "=== checking dependencies ==="
for dep in "${DEPENDENCIES[@]}"; do
	install_if_missing "$dep"
done

# init project
npm install --omit=dev
npm start

# for development, use this instead
# npm install --save-dev nodemon
# npm run start:dev

