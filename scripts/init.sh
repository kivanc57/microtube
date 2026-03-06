#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

APP_TAG="microtube:latest"
REGISTRY_APP_TAG="${APP_TAG}"
DEPENDENCIES=(git docker nvm)

source "${SCRIPT_DIR}/../.env"
source "${SCRIPT_DIR}/install/install-utils.sh"

PORT="${PORT:-3000}"
: "${REGISTRY_URL:?REGISTRY_URL not set}"
: "${REGISTRY_USERNAME:?REGISTRY_USERNAME not set}"
: "${REGISTRY_PASSWORD:?REGISTRY_PASSWORD not set}"

# set logger func
log() { printf '\n[%s] %s\n' "$(date -Is)" "$*"; }

# login Microsoft Azure registry
if ! docker login "${REGISTRY_URL}" --username "${REGISTRY_USERNAME}" --password "${REGISTRY_PASSWORD}"; then
	log "[FAILED]: logging in Microsoft Azure registry"
	exit 1
else
	log "[SUCCESS]: logging in Microsoft Azure registry"
fi

# check & install necessary dependencies
log "=== checking dependencies ==="
for dep in "${DEPENDENCIES[@]}"; do
	install_if_missing "$dep"
done

# init project: build, tag and push to Microsoft Azure registry
if ! docker build -t ${APP_TAG} -f ../Dockerfile ..; then
	log "[FAILED]: building Docker image"
	exit 1
else
	log "[SUCCESS] building Docker image"
	
	if ! docker tag "${APP_TAG}" "${REGISTRY_URL}"/"${REGISTRY_APP_TAG}"; then
		log "[FAILED]: tagging Docker image"
		exit 1
	else
		log "[SUCCESS]: tagging Docker image"

		if ! docker push "${REGISTRY_URL}"/"${REGISTRY_APP_TAG}"; then
			log "[FAILED]: pushing Docker image to Microsoft Azure registry on ${REGISTRY_URL}"
			exit 1
		else
			log "[SUCCESS] pushing Docker image to Microsoft Azure registry on ${REGISTRY_URL}"

			if ! docker run -d -p "${PORT}:${PORT}" -e PORT="${PORT}" "${REGISTRY_URL}"/"${REGISTRY_APP_TAG}"; then
				log "[FAILED]: running Docker image from Microsoft Registry on ${REGISTRY_URL} on PORT=${PORT}"
				exit 1
			else
				log "[SUCCESS]: running Docker image from Microsoft Registry on ${REGISTRY_URL} on PORT=${PORT}"
			fi
		fi
	fi
fi

## if you want to  build, run Docker image locally, do this instead:
#if ! docker build -t ${APP_TAG} -f ../Dockerfile ..; then
#        log "[FAILED]: building Docker image"
#        exit 1
#else
#        log "[SUCCESS] building Docker image"
#
#	if ! docker run -d -p "${PORT}":"${PORT}" -e PORT="${PORT}" -t "${APP_TAG}"; then
#		log "[FAILED]: running Docker container on PORT=${PORT}"
#		exit 1
#	else
#		log "[SUCCESS]: running Docker container on PORT=${PORT}"
#fi

