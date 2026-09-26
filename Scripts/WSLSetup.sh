#!/bin/bash
# WSL initial setup script.
# Run this once after installing WSL (wsl --install) and launching Ubuntu for the first time.

set -e

# Update packages
sudo apt update && sudo apt upgrade -y

# Git configuration: include the repo's git config (identity and shared settings) from the Windows clone
# this script runs from, instead of repeating it. Its conditional includes (work) resolve next
# to it; they need git 2.36+ (Ubuntu 24.04 and later).
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
shared_gitconfig="$repo/home/dot_config/git/config"
# It used to be Config/Git/gitconfig; drop an include of that path left by an earlier run
git config --global --fixed-value --unset-all include.path "$repo/Config/Git/gitconfig" || true
if ! git config --global --get-all include.path | grep -qxF "$shared_gitconfig"; then
    git config --global --add include.path "$shared_gitconfig"
fi
# Settings below come after the include in ~/.gitconfig, so they override it.
# Git's built-in fsmonitor is Windows/macOS only.
git config --global core.fsmonitor false

# Use Windows Git Credential Manager so WSL shares credentials with the host
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

# Required for Azure DevOps repos (uses full path as key, not just hostname)
git config --global credential.https://dev.azure.com.useHttpPath true

# Install JetBrains Rider via snap (optional)
read -rp "Do you want to install JetBrains Rider? (Y/N) " rider_confirmation
if [[ "$rider_confirmation" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    sudo snap install rider --classic
else
    echo "Skipping JetBrains Rider installation."
fi
