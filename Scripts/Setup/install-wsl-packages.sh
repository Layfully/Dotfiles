#!/bin/bash
# Installs the command-line tools the WSL bash setup uses, and hooks ~/.config/bash/dotfiles.sh into
# ~/.bashrc. chezmoi runs this in WSL when this script changes (home/.chezmoiscripts/run_onchange_after_20-packages-wsl.sh.tmpl).
set -euo pipefail

# fzf, zoxide and delta (git's pager, see home/dot_config/git/config) from Ubuntu (asks for your password once)
sudo apt-get update -qq
sudo apt-get install -y -qq fzf zoxide git-delta

# oh-my-posh isn't packaged for Ubuntu; its installer puts one binary in ~/.local/bin
if ! command -v oh-my-posh >/dev/null && [[ ! -x "$HOME/.local/bin/oh-my-posh" ]]; then
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi

# Leave Ubuntu's ~/.bashrc alone apart from one line that loads the shared setup
hook='[ -f ~/.config/bash/dotfiles.sh ] && . ~/.config/bash/dotfiles.sh'
if ! grep -qxF "$hook" "$HOME/.bashrc" 2>/dev/null; then
    printf '\n# Dotfiles (chezmoi)\n%s\n' "$hook" >> "$HOME/.bashrc"
    echo "Added the dotfiles hook to ~/.bashrc - open a new shell to load it."
fi
