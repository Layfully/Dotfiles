# shellcheck shell=bash
# Bash setup in WSL, sourced from ~/.bashrc (Scripts/Setup/install-wsl-packages.sh adds that line), so
# Ubuntu's own ~/.bashrc stays as it is. The prompt theme is the one pwsh uses on Windows.

# Interactive shells only
[[ $- == *i* ]] || return

export PATH="$HOME/.local/bin:$PATH"

if command -v oh-my-posh >/dev/null; then
    eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/cloud-context.omp.json)"
fi

# z / zi, as in pwsh
if command -v zoxide >/dev/null; then
    eval "$(zoxide init bash)"
fi

# Ctrl+R (history), Ctrl+T (files), Alt+C (cd). fzf 0.48+ prints its own bindings; Ubuntu's older
# package ships them as a file.
if command -v fzf >/dev/null; then
    if fzf --bash >/dev/null 2>&1; then
        eval "$(fzf --bash)"
    elif [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
        # shellcheck source=/dev/null
        . /usr/share/doc/fzf/examples/key-bindings.bash
    fi
fi

# The same short names as the pwsh profile
alias g=git
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gf='git fetch origin'
alias ll='ls -l'
command -v lazygit >/dev/null && alias lg=lazygit
