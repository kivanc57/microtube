#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# source necessary files
source "${SCRIPT_DIR}/../.env"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/docker.sh"

# app-specific constants
APP_NAME="microtube"
APP_TAG="${APP_NAME}:latest"
DEPENDENCIES=(git docker nvm)
DOCKERFILE_PATH="${SCRIPT_DIR}/../Dockerfile"
BUILD_CONTEXT="${SCRIPT_DIR}/.."
PORT="${PORT:-3000}"

# check environment variables
log "Checking environtment variables..."
require_env REGISTRY_URL
require_env REGISTRY_USERNAME
require_env REGISTRY_PASSWORD

# registry specific constants
REGISTRY_APP_TAG="${APP_TAG}"
TARGET_IMAGE="${REGISTRY_URL}/${REGISTRY_APP_TAG}"

# check & install necessary dependencies
log "Checking dependencies..."
for dep in "${DEPENDENCIES[@]}"; do
	install_if_missing "$dep"
done

# main functions
run_on_local(){
	docker_build_image  "${APP_TAG}" "${DOCKERFILE_PATH}" "${BUILD_CONTEXT}"
	docker_run_image "${APP_NAME}" "${APP_TAG}" "${PORT}" "${PORT}"

}

run_on_remote(){
	docker_login_registry "${REGISTRY_URL}" "${REGISTRY_USERNAME}" "${REGISTRY_PASSWORD}"
	docker_build_image  "${APP_TAG}" "${DOCKERFILE_PATH}" "${BUILD_CONTEXT}"
	docker_tag_image "${APP_TAG}" "${TARGET_IMAGE}"
	docker_push_image "${TARGET_IMAGE}"
	docker_run_image "${APP_NAME}" "${TARGET_IMAGE}" "${PORT}" "${PORT}"
}

