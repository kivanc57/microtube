#!/bin/bash
set -euo pipefail

install_if_missing(){
	local cmd="$1"
	local script="./install-${cmd}".sh

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
