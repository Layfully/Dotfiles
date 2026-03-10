# Dotfiles — Claude Context

## What This Repo Is
Windows dotfiles and machine setup automation for **Adrian Gaborek**.
Configs are symlinked from this repo into their expected system locations by `Scripts/Tools.ps1`.

## Two-Machine Setup
- **Work machine**: `DEV-WNW-422A` — currently the active machine in this session
- **Private machine**: different hostname — the "source of truth" for personal configs in the repo

Key implication: work-machine-specific files (UniGetUI runtime state, winget bundle named `DEV-WNW-422A*`) are gitignored. The private machine's bundle (different filename) is what gets tracked.

## Repo Structure
```
Config/               # All tracked config files (symlinked to system locations)
  user_profile.ps1    # PowerShell profile → $PROFILE
  VisualStudioCode/   # settings.json, extensions list → %APPDATA%\Code\User\
  WindowsTerminal/    # settings.json → %LOCALAPPDATA%\...\WindowsTerminal\
  UniGetUI/           # Config dir → %LOCALAPPDATA%\UniGetUI\Configuration (symlink)
  PowerToys/          # latest_powertoys_backup.ptb
  VisualStudio/       # installationConfig2022.vsconfig
Scripts/
  Tools.ps1           # Main setup script — run once on a new machine (requires Admin + pwsh 7+)
  WSLSetup.sh         # WSL first-time setup
  GitHooks/           # Scripts called by .githooks/pre-commit
    UpdatePowerToysBackup.ps1
    SaveVsCodeExtensions.ps1   # Uses code.cmd (not Code.exe) — see file for why
    SaveVsInstallProfile.ps1
    ExportWingetPackages.ps1   # Named after $env:COMPUTERNAME; gitignored on work machine
UniGetUI/             # Winget package bundles (private machine bundle tracked here)
.githooks/
  pre-commit          # Runs all GitHooks scripts + stages their output automatically
```

## Important Conventions
- **Git hooks**: must be enabled after cloning with `git config --local core.hooksPath .githooks`
- **Symlinks**: created by `Tools.ps1` — editing files in `Config/` edits the live config
- **Pre-commit hook**: runs in Windows PowerShell 5.1 (via `powershell.exe`), NOT pwsh 7. Avoid PS7-only syntax (e.g. `?.`) in GitHooks scripts. `Tools.ps1` itself runs under pwsh 7 and can use modern syntax.
- **Gitignored UniGetUI files**: `CurrentSessionToken`, `OperationHistory`, `WindowGeometry`, `TelemetryClientToken` — these are runtime state, don't try to commit them
- **mssql connections**: intentionally omitted from `settings.json` (contain work server names/IPs)

## Common Tasks
- **Sync configs to GitHub**: just `git add` the changed files and commit — hooks auto-update backups
- **New machine setup**: clone repo → enable hooks → run `Scripts/Tools.ps1` as Admin in pwsh 7
- **Add a new tool**: add winget ID to `$wingetPackages` in `Scripts/Tools.ps1`
- **Add a new PS alias**: add to the `#Alias` section in `Config/user_profile.ps1`
- **Add a new symlink**: add entry to `$configItems` in `Scripts/Tools.ps1`

## Installed Tools (via Tools.ps1)
winget: PowerToys, fzf, Windows Terminal, GitHub CLI, Oh My Posh, PowerShell 7, UniGetUI, Git, Bitwarden, VS Code, lazygit, nvm-windows
npm (via nvm): Claude Code CLI (`@anthropic-ai/claude-code`)
choco: JetBrainsMono Nerd Font
PS modules: ZLocation, PSFzf, CompletionPredictor, posh-git, Terminal-Icons, Az
