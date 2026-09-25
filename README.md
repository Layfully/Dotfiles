# Dotfiles

Windows dotfiles and machine setup: PowerShell profile, Windows Terminal, VS Code, Git, lazygit, Claude Code, UniGetUI and PowerToys configs, plus a script that installs the tools and links these configs into place on a new machine.

## Prerequisites

- [Git](https://git-scm.com/) — required to clone and run hooks
- [winget](https://learn.microsoft.com/en-us/windows/package-manager/) — built into Windows 11
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) (`winget install Microsoft.PowerShell`)

## First-Time Setup

```powershell
# 1. Clone the repo (any location works; scripts and hooks find the repo themselves)
git clone https://github.com/Layfully/Dotfiles "$env:USERPROFILE\Dotfiles"
cd "$env:USERPROFILE\Dotfiles"

# 2. Run the main setup script (installs tools, creates symlinks, sets up PS modules, enables git hooks)
#    Run as Administrator in a clean PowerShell 7 session
pwsh -NoProfile -File Scripts/Tools.ps1
```

Optional components are asked about once at the start. To answer ahead of time, pass a switch to install (`-Node`) or skip (`-Node:$false`); with all four given the run needs no input:

```powershell
pwsh -NoProfile -File Scripts/Tools.ps1 -GitHubCli -Node -Claude -Az:$false
```

## What the Setup Script Does (`Scripts/Tools.ps1`)

| Step | What happens |
|------|-------------|
| Installs winget packages | PowerToys, fzf, Windows Terminal, Oh My Posh, PowerShell 7, UniGetUI, Git, Bitwarden (app and CLI), VS Code, lazygit, nvm-windows, zoxide |
| Installs GitHub CLI | Optional (`-GitHubCli`) |
| Installs Node.js LTS via nvm | Optional (`-Node`) |
| Installs Claude Code CLI | Optional (`-Claude`): native build to `%USERPROFILE%\.local\bin`, and adds that folder to the User PATH |
| Installs JetBrainsMono Nerd Font | Through `oh-my-posh font install` |
| Installs PowerShell modules | PSFzf, CompletionPredictor, posh-git, Terminal-Icons |
| Installs Az modules | Optional (`-Az`) |
| Creates symbolic links | Links config files from this repo into their expected system locations (see table below). Links that are already correct are skipped; an existing real file or folder is renamed to `<name>.<timestamp>.bak` first |
| Sets UniGetUI's backup folder | Writes this clone's path to `Config/UniGetUI/ChangeBackupOutputDirectory` (gitignored, as the path differs per machine) |
| Enables git hooks | Sets `core.hooksPath` to `.githooks` |
| Installs VS Code extensions | Installs whatever in `Config/VisualStudioCode/extensions` (or `extensions.work` on a work machine) is missing |
| Cleans up old PS modules | Removes all but the latest version of each module installed from the PowerShell Gallery (modules that ship with Windows are left alone) |

## Symbolic Links

| Symlink location | Points to |
|-----------------|-----------|
| `$PROFILE` | `Config/user_profile.ps1` |
| `%APPDATA%\Code\User\settings.json` | `Config/VisualStudioCode/settings.json` |
| `%LOCALAPPDATA%\...\WindowsTerminal\settings.json` | `Config/WindowsTerminal/settings.json` |
| `%LOCALAPPDATA%\UniGetUI\Configuration` | `Config/UniGetUI/` |
| `%LOCALAPPDATA%\lazygit\config.yml` | `Config/lazygit/config.yml` |
| `%USERPROFILE%\.gitconfig` | `Config/Git/gitconfig` (machine-specific settings go in `~/.gitconfig-local`, which it includes) |
| `%USERPROFILE%\.claude\settings.json` | `Config/Claude/settings.json` |
| `C:\Tools\pwsh.exe` | `pwsh.exe` of the running PowerShell 7 install (`$PSHOME`) |

## Machine-Local Profile

Functions and aliases for one machine only (work tools, local paths) go in `%USERPROFILE%\.user_profile_local.ps1`. It is not part of the repo; the profile loads it last if it exists, the way the gitconfig includes `~/.gitconfig-local`.

## WSL Setup

After running `wsl --install` and launching Ubuntu:

```bash
# The Windows clone is under /mnt/c; adjust the path if you cloned elsewhere
bash "$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")/Dotfiles/Scripts/WSLSetup.sh"
```

The WSL `~/.gitconfig` includes `Config/Git/gitconfig` from the Windows clone, so the identity and shared settings are defined once.

## Git Hooks

Hooks run automatically on every commit to keep config snapshots up to date:

| Hook | What it does |
|------|-------------|
| `UpdatePowerToysBackup.ps1` | Renames the latest `.ptb` backup to `latest_powertoys_backup.ptb` |
| `SaveVsCodeExtensions.ps1` | Exports the installed VS Code extensions: to `extensions` on the private machine, to `extensions.work` on work machines (`DEV-WNW-*` hostnames) |

`Scripts/Tools.ps1` enables them; to do it by hand without running setup:

```bash
git config --local core.hooksPath .githooks
```

The hooks run under Windows PowerShell 5.1, so `Scripts/GitHooks/*.ps1` must avoid PowerShell 7-only syntax and non-ASCII characters.

## Linting

`.github/workflows/lint.yml` runs on every push to `main` and on pull requests. It parses the hook scripts with Windows PowerShell 5.1 and runs PSScriptAnalyzer over every `.ps1`, using the rules in `PSScriptAnalyzerSettings.psd1`. The VS Code PowerShell extension reads the same settings file, so the editor shows the same warnings.

## Shell Shortcuts (PowerShell profile)

| Shortcut | Action |
|----------|--------|
| `Ctrl+F` | Fuzzy finder (fzf) |
| `Ctrl+R` | Fuzzy search command history |
| `Alt+C` | Fuzzy cd into directory |
| `z <partial>` | Jump to a frecent directory (zoxide) |
| `gs` | `git status` |
| `gl` | `git pull` |
| `gp` | `git push` |
| `gf` | `git fetch origin` |
| `fgs` | Fuzzy git status |
| `fe` | Fuzzy open file in editor |
| `fkill` | Fuzzy kill process |
| `lg` | lazygit (terminal git UI) |
