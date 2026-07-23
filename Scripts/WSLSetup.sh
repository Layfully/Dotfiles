#!/bin/bash
# WSL initial setup script.
# Run this once after installing WSL (wsl --install) and launching Ubuntu for the first time.

set -e

# Update packages
sudo apt update && sudo apt upgrade -y

# Git configuration
git config --global user.name "Adrian Gaborek"
git config --global user.email "git@adriangaborek.dev"

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
