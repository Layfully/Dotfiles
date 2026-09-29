#!/bin/bash
# WSL setup: run it once after installing WSL (wsl --install) and launching Ubuntu for the first time, from
# the Windows clone. chezmoi then manages WSL from that same clone - git config, the prompt theme and the
# bash setup (see home/.chezmoiignore for what WSL gets). Afterwards, `chezmoi update` keeps it in sync.

set -e

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Update packages
sudo apt update && sudo apt upgrade -y

# chezmoi, into ~/.local/bin (Ubuntu doesn't package it): a pinned release checked against its release checksum,
# the same one CI uses (.github/workflows/lint.yml). Later updates: `chezmoi upgrade`.
chezmoi_version=2.72.2
chezmoi_sha256=a2be1b8bcdf06c6f173e070bb3ddbcc52c50478fe9b57f6e6c63d15c7cff4f03
if ! command -v chezmoi >/dev/null && [[ ! -x "$HOME/.local/bin/chezmoi" ]]; then
    archive="$(mktemp)"
    curl -fsSLo "$archive" "https://github.com/twpayne/chezmoi/releases/download/v${chezmoi_version}/chezmoi_${chezmoi_version}_linux_amd64.tar.gz"
    echo "$chezmoi_sha256  $archive" | sha256sum -c --quiet -
    mkdir -p "$HOME/.local/bin"
    tar -xzf "$archive" -C "$HOME/.local/bin" chezmoi
    rm "$archive"
fi
export PATH="$HOME/.local/bin:$PATH"

# Copies the configs and runs the WSL setup script (fzf, zoxide, oh-my-posh, delta, the ~/.bashrc hook)
chezmoi init --apply --source "$repo"
