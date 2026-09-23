# Dotfiles — Claude Context

## What This Repo Is
Windows dotfiles and machine setup automation for **Adrian Gaborek**.
Configs are symlinked from this repo into their expected system locations by `Scripts/Tools.ps1`.

## Two-Machine Setup
- **Work machine**: `DEV-WNW-422A` — currently the active machine in this session
- **Private machine**: different hostname — the "source of truth" for personal configs in the repo

Key implication: work-machine-specific files (UniGetUI runtime state, winget bundle matching `DEV-WNW-*`) are gitignored. The private machine's bundle (different filename) is what gets tracked, but only if the top-level `UniGetUI/` folder exists (winget can't create it). It was emptied upstream, so currently no bundle is exported or tracked.

## Repo Structure
```
Config/               # All tracked config files (symlinked to system locations)
  user_profile.ps1    # PowerShell profile → $PROFILE
  user_profile_autopairing.ps1  # Quote/bracket key handlers; loaded by the profile when idle (not symlinked)
  oh-my-posh/         # cloud-context.omp.json — local prompt theme used by the profile
  VisualStudioCode/   # settings.json, extensions list → %APPDATA%\Code\User\
  WindowsTerminal/    # settings.json → %LOCALAPPDATA%\...\WindowsTerminal\
  UniGetUI/           # Config dir → %LOCALAPPDATA%\UniGetUI\Configuration (symlink)
  PowerToys/          # latest_powertoys_backup.ptb
Scripts/
  Tools.ps1           # Main setup script — run once on a new machine (requires Admin + pwsh 7+)
  WSLSetup.sh         # WSL first-time setup
  GitHooks/           # Scripts called by .githooks/pre-commit
    UpdatePowerToysBackup.ps1
    SaveVsCodeExtensions.ps1   # Uses code.cmd (not Code.exe) — see file for why
    ExportWingetPackages.ps1   # Named after $env:COMPUTERNAME; gitignored on work machine; skipped if UniGetUI/ is missing
UniGetUI/             # Winget package bundles, only if this folder exists (currently absent)
.githooks/
  pre-commit          # Runs all GitHooks scripts + stages their output automatically
```

## Important Conventions
- **Git hooks**: must be enabled after cloning with `git config --local core.hooksPath .githooks`
- **Symlinks**: created by `Tools.ps1` — editing files in `Config/` edits the live config
- **Pre-commit hook**: runs in Windows PowerShell 5.1 (via `powershell.exe`), NOT pwsh 7. Avoid PS7-only syntax (e.g. `?.`) in GitHooks scripts. `Tools.ps1` itself runs under pwsh 7 and can use modern syntax.
- **Gitignored UniGetUI files**: `CurrentSessionToken`, `OperationHistory`, `WindowGeometry`, `TelemetryClientToken` — these are runtime state, don't try to commit them
- **mssql connections**: intentionally omitted from `settings.json` (contain work server names/IPs)
- **Profile startup is tuned** (see comments in `user_profile.ps1`): nothing before the first prompt may use cmdlets from Microsoft.PowerShell.Management/Utility (`Get-Item`, `Test-Path`, `Set-Alias`, `Register-EngineEvent`, ...) — use .NET/engine APIs instead; modules load lazily on first use; oh-my-posh/zoxide init scripts are cached and patched in `%LOCALAPPDATA%\PowerShellProfileCache` (bump the `v4` cache key after changing a `$Generate` block). Never set `Set-PSReadLineOption -EditMode` below custom key bindings — it resets them.

## Common Tasks
- **Sync configs to GitHub**: just `git add` the changed files and commit — hooks auto-update backups
- **New machine setup**: clone repo → enable hooks → run `Scripts/Tools.ps1` as Admin in pwsh 7
- **Add a new tool**: add winget ID to `$wingetPackages` in `Scripts/Tools.ps1`
- **Add a new PS alias**: add a `${alias:name} = 'target'` line to the `#Alias` section in `Config/user_profile.ps1` (not `Set-Alias` — it loads the Utility module at startup)
- **Add a new symlink**: add entry to `$configItems` in `Scripts/Tools.ps1`

## Installed Tools (via Tools.ps1)
winget: PowerToys, fzf, Windows Terminal, GitHub CLI, Oh My Posh, PowerShell 7, UniGetUI, Git, Bitwarden, VS Code, lazygit, nvm-windows, zoxide
npm (via nvm): Claude Code CLI (`@anthropic-ai/claude-code`)
choco: JetBrainsMono Nerd Font
PS modules: PSFzf, CompletionPredictor, posh-git, Terminal-Icons, Az
