#!/bin/bash
# WSL setup: run it once after installing WSL (wsl --install) and launching Ubuntu for the first time, from
# the Windows clone. chezmoi then manages WSL from that same clone - git config, the prompt theme and the
# bash setup (see home/.chezmoiignore for what WSL gets). Afterwards, `chezmoi update` keeps it in sync.

set -e

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Update packages
sudo apt update && sudo apt upgrade -y

# chezmoi, into ~/.local/bin (Ubuntu doesn't package it)
if ! command -v chezmoi >/dev/null && [[ ! -x "$HOME/.local/bin/chezmoi" ]]; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi
export PATH="$HOME/.local/bin:$PATH"

# Copies the configs and runs the WSL setup script (fzf, zoxide, oh-my-posh, delta, the ~/.bashrc hook)
chezmoi init --apply --source "$repo"
