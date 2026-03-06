#!/bin/bash
set -euo pipefail

NAME="Kivanc Gordu"
EMAIL="kivancgordu@hotmail.com"

# install git
sudo apt-get update
sudo apt-get install -y git
git -v

# config git
git config --global user.name "${NAME}"
git config --global user.email "${EMAIL}"
git config --global pull.ff only
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global push.autoSetupRemote true
git config --global core.editor "vim"

# generate git hosting
ssh-keygen -t ed25519 -C "${EMAIL}"

# show the key
echo "=== key is generated ==="
cat ~/.ssh/id_ed25519.pub
echo "copy this key to git platform"

