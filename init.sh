#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

export PORT=3000
PROJECT_NAME="microtube"
DEPENDENCIES=(git docker nvm)

source "${SCRIPT_DIR}/dependencies/install-utils.sh"

# check & install necessary dependencies
echo "=== checking dependencies ==="
for dep in "${DEPENDENCIES[@]}"; do
	install_if_missing "$dep"
done

# init project
npm install --omit=dev
npm start

# for development, use this instead
# npm install --save-dev nodemon
# npm run start:dev

