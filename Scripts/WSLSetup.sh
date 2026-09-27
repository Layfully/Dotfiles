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

# Earlier versions of this script wrote the git settings into ~/.gitconfig. They come from ~/.config/git now
# (home/dot_config/git: config, os, work), and git would read ~/.gitconfig ahead of it, so drop them there.
if [[ -f "$HOME/.gitconfig" ]]; then
    for old_include in "$repo/Config/Git/gitconfig" "$repo/home/dot_config/git/config"; do
        git config --file "$HOME/.gitconfig" --fixed-value --unset-all include.path "$old_include" || true
    done
    git config --file "$HOME/.gitconfig" --unset core.fsmonitor || true
    git config --file "$HOME/.gitconfig" --unset credential.helper || true
    git config --file "$HOME/.gitconfig" --unset credential.https://dev.azure.com.useHttpPath || true
    # Nothing left but empty section headers: remove the file
    if ! grep -qE '^\s*[^[#;[:space:]]' "$HOME/.gitconfig"; then
        rm "$HOME/.gitconfig"
        echo "Removed the old ~/.gitconfig."
    fi
fi

# Links the configs and runs the WSL setup script (fzf, zoxide, oh-my-posh, the ~/.bashrc hook)
chezmoi init --apply --source "$repo"

# Install JetBrains Rider via snap (optional)
read -rp "Do you want to install JetBrains Rider? (Y/N) " rider_confirmation
if [[ "$rider_confirmation" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    sudo snap install rider --classic
else
    echo "Skipping JetBrains Rider installation."
fi
