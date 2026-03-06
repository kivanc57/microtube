#!/bin/bash
set -euo pipefail

log() {
        printf '\n[%s] %s\n' "$(date -Is)" "$*"
}

require_env() {
        local var="$1"
        if [[ -z "${!var:-}" ]]; then
                echo "[ERROR]: '$var' is NOT set"
                exit 1
        fi
}

install_if_missing(){
        local cmd="$1"
        local script="./install/install-${cmd}.sh"

        if !command -v "$1" >/dev/null 2>&1; then
                echo "$1 NOT installed. Installing..."

                if [ -f "${script}" ]; then
                        bash "${script}"
                else
                        echo "install script ${script} not found"
                        exit 1
                fi
        else
                echo "$1 already installed"
        fi
}

