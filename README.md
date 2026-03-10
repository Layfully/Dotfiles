# WindowsSetup

A collection of personalized configuration files for package managers, terminals, Windows settings, and keyboard layouts. Curated over time to optimize new machine setup.

## Prerequisites

- [Git](https://git-scm.com/) — required to clone and run hooks
- [winget](https://learn.microsoft.com/en-us/windows/package-manager/) — built into Windows 11
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) (`winget install Microsoft.PowerShell`)

## First-Time Setup

```powershell
# 1. Clone the repo
git clone https://github.com/Layfully/Dotfiles "$env:USERPROFILE\Dotfiles"
cd "$env:USERPROFILE\Dotfiles"

# 2. Enable git hooks
git config --local core.hooksPath .githooks

# 3. Run the main setup script (installs tools, creates symlinks, sets up PS modules)
#    Run as Administrator in a clean PowerShell 7 session
pwsh -NoProfile -File Scripts/Tools.ps1
```

## What the Setup Script Does (`Scripts/Tools.ps1`)

| Step | What happens |
|------|-------------|
| Installs winget packages | PowerToys, fzf, Windows Terminal, GitHub CLI, Oh My Posh, PowerShell 7, UniGetUI, Git, Bitwarden, VS Code, lazygit, nvm-windows |
| Installs Node.js LTS via nvm | Then installs Claude Code CLI (`@anthropic-ai/claude-code`) globally |
| Installs Chocolatey | Used for JetBrainsMono Nerd Font |
| Installs PowerShell modules | ZLocation, PSFzf, CompletionPredictor, posh-git, Terminal-Icons, Az |
| Creates symbolic links | Links config files from this repo into their expected system locations (see table below) |
| Cleans up old PS modules | Removes all but the latest version of each installed module |

## Symbolic Links

| Symlink location | Points to |
|-----------------|-----------|
| `$PROFILE` | `Config/user_profile.ps1` |
| `%APPDATA%\Code\User\settings.json` | `Config/VisualStudioCode/settings.json` |
| `%LOCALAPPDATA%\...\WindowsTerminal\settings.json` | `Config/WindowsTerminal/settings.json` |
| `%LOCALAPPDATA%\UniGetUI\Configuration` | `Config/UniGetUI\` |

## WSL Setup

After running `wsl --install` and launching Ubuntu:

```bash
bash "$env:USERPROFILE/Dotfiles/Scripts/WSLSetup.sh"
```

## Git Hooks

Hooks run automatically on every commit to keep config snapshots up to date:

| Hook | What it does |
|------|-------------|
| `UpdatePowerToysBackup.ps1` | Renames the latest `.ptb` backup to `latest_powertoys_backup.ptb` |
| `SaveVsCodeExtensions.ps1` | Exports installed VS Code extensions list |
| `SaveVsInstallProfile.ps1` | Exports Visual Studio 2022 installation config |
| `ExportWingetPackages.ps1` | Exports winget package list (named after the machine) |

To enable hooks after cloning:

```bash
git config --local core.hooksPath .githooks
```

## Shell Shortcuts (PowerShell profile)

| Shortcut | Action |
|----------|--------|
| `Ctrl+F` | Fuzzy finder (fzf) |
| `Ctrl+R` | Fuzzy search command history |
| `Alt+C` | Fuzzy cd into directory |
| `z <partial>` | Jump to a frecent directory (ZLocation) |
| `gs` | `git status` |
| `gl` | `git pull` |
| `gp` | `git push` |
| `gf` | `git fetch origin` |
| `fgs` | Fuzzy git status |
| `fe` | Fuzzy open file in editor |
| `fkill` | Fuzzy kill process |
| `lg` | lazygit (terminal git UI) |
