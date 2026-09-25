# Dotfiles — Claude Context

## What This Repo Is
Windows dotfiles and machine setup automation for **Adrian Gaborek**.
Configs are symlinked from this repo into their expected system locations by `Scripts/Tools.ps1`.

## Two-Machine Setup
- **Work machine**: `DEV-WNW-422A` (work machines are recognised by the `DEV-WNW-*` hostname)
- **Private machine**: different hostname — the "source of truth" for personal configs in the repo

Key implication: work-machine-specific files (UniGetUI runtime state, UniGetUI's package backup `DEV-WNW-* installed packages.ubundle`) are gitignored. UniGetUI writes that backup to the repo root (`Tools.ps1` sets `ChangeBackupOutputDirectory` to the clone), so the private machine's backup, under a different hostname, shows up as untracked there.

## Repo Structure
```
Config/               # All tracked config files (symlinked to system locations)
  user_profile.ps1    # PowerShell profile → $PROFILE
  user_profile_autopairing.ps1  # Quote/bracket key handlers; loaded by the profile when idle (not symlinked)
  oh-my-posh/         # cloud-context.omp.json — local prompt theme used by the profile
  VisualStudioCode/   # settings.json → %APPDATA%\Code\User\; extensions (private) and extensions.work lists
  WindowsTerminal/    # settings.json → %LOCALAPPDATA%\...\WindowsTerminal\
  UniGetUI/           # Config dir → %LOCALAPPDATA%\UniGetUI\Configuration (symlink)
  Git/                # gitconfig → ~/.gitconfig (includes ~/.gitconfig-local for machine-specific settings)
  lazygit/            # config.yml → %LOCALAPPDATA%\lazygit\
  Claude/             # settings.json → ~/.claude/
  PowerToys/          # latest_powertoys_backup.ptb
Scripts/
  Tools.ps1           # Main setup script — run once on a new machine (requires Admin + pwsh 7+)
  WSLSetup.sh         # WSL first-time setup; WSL ~/.gitconfig includes Config/Git/gitconfig
  GitHooks/           # Scripts called by .githooks/pre-commit
    UpdatePowerToysBackup.ps1
    SaveVsCodeExtensions.ps1   # Uses code.cmd (not Code.exe) — see file for why; writes extensions.work on DEV-WNW-*
.githooks/
  pre-commit          # Runs all GitHooks scripts + stages their output automatically
.github/workflows/
  lint.yml            # Parses GitHooks scripts with PS 5.1 + PSScriptAnalyzer on all .ps1 (rules: PSScriptAnalyzerSettings.psd1)
.gitattributes        # All text files are LF on checkout (overrides Git for Windows' core.autocrlf=true)
```

## Important Conventions
- **Git hooks**: enabled by `Tools.ps1` (`git config --local core.hooksPath .githooks`); run that by hand if you skip setup
- **Symlinks**: created by `Tools.ps1` — editing files in `Config/` edits the live config
- **Pre-commit hook**: runs in Windows PowerShell 5.1 (via `powershell.exe`), NOT pwsh 7. Avoid PS7-only syntax (e.g. `?.`) and non-ASCII characters (5.1 reads BOM-less files in the system code page) in GitHooks scripts; CI checks both. `Tools.ps1` itself runs under pwsh 7 and can use modern syntax.
- **Gitignored UniGetUI files**: `CurrentSessionToken`, `OperationHistory`, `WindowGeometry`, `TelemetryClientToken`, `IpcApiEndpoints/` — these are runtime state, don't try to commit them. `ChangeBackupOutputDirectory` holds a local path, so it is gitignored too and `Tools.ps1` writes it per machine
- **mssql connections**: intentionally omitted from `settings.json` (contain work server names/IPs)
- **Profile startup is tuned** (see comments in `user_profile.ps1`): nothing before the first prompt may use cmdlets from Microsoft.PowerShell.Management/Utility (`Get-Item`, `Test-Path`, `Set-Alias`, `Register-EngineEvent`, ...) — use .NET/engine APIs instead; modules load lazily on first use; oh-my-posh/zoxide init scripts are cached and patched in `%LOCALAPPDATA%\PowerShellProfileCache` (bump the `v4` cache key after changing a `$Generate` block). Never set `Set-PSReadLineOption -EditMode` below custom key bindings — it resets them.
- **User PATH edits**: `HKCU:\Environment\Path` is `REG_EXPAND_SZ` and contains `%USERPROFILE%`, `%NVM_HOME%` and `%NVM_SYMLINK%` tokens. Write it with `Set-ItemProperty -Type ExpandString` and read it with `GetValue('Path','','DoNotExpandEnvironmentNames')`. `[Environment]::SetEnvironmentVariable(...,'User')` expands those tokens and bakes them out permanently, breaking the nvm indirection.

## Common Tasks
- **Sync configs to GitHub**: just `git add` the changed files and commit — hooks auto-update backups
- **New machine setup**: clone repo → run `Scripts/Tools.ps1` as Admin in pwsh 7 (it enables the hooks)
- **Add a new tool**: add winget ID to `$wingetPackages` in `Scripts/Tools.ps1`
- **Machine-only profile code** (work tools, local paths): `~/.user_profile_local.ps1`, untracked, dot-sourced at the end of the profile — never put it in `user_profile.ps1`, the repo is public
- **Add a new PS alias**: add a `${alias:name} = 'target'` line to the `#Alias` section in `Config/user_profile.ps1` (not `Set-Alias` — it loads the Utility module at startup)
- **Add a new symlink**: add entry to `$configItems` in `Scripts/Tools.ps1`

## Installed Tools (via Tools.ps1)
winget: PowerToys, fzf, Windows Terminal, Oh My Posh, PowerShell 7, UniGetUI, Git, Bitwarden, VS Code, lazygit, nvm-windows, zoxide
font: JetBrainsMono Nerd Font (via `oh-my-posh font install`)
PS modules: PSFzf, CompletionPredictor, posh-git, Terminal-Icons
optional (a switch, or asked once at the start): GitHub CLI (`-GitHubCli`), Node.js LTS via nvm (`-Node`), Claude Code CLI (`-Claude`, native installer → `%USERPROFILE%\.local\bin\claude.exe`, folder added to the User PATH), Az modules (`-Az`)
