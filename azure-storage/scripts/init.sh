#!/bin/bash
set -euo pipefail

# script constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# source necessary files
source "${SCRIPT_DIR}/../.env"
source "utils.sh"

# require environment variables
log "Checking environment varibles..."
require_env STORAGE_ACCOUNT_NAME
require_env STORAGE_ACCESS_KEY

# app=specific constants
PORT="${PORT:-3000}"
DEPENDENCIES=(git docker nvm)

# check & install necessary dependencies
log "Checking dependencies..."
for dep in "${DEPENDENCIES[@]}"; do
        install_if_missing "$dep"
done

# init npm
npm start

