# Dotfiles — Claude Context

## What This Repo Is
Windows dotfiles and machine setup for **Adrian Gaborek**, managed with **chezmoi** in symlink mode. The repo is public.

## Two-Machine Setup: Base + Work Overlay
- **Private machine** (hostname `Edek`): its setup is the base — everything in `home/`.
- **Work machine** (`DEV-WNW-422A`; `DEV-WNW-*` hostnames default to the work role): base + the work overlay.
- The role lives in `~/.config/chezmoi/chezmoi.toml` (`[data] role`), written by `chezmoi init` from `home/.chezmoi.toml.tmpl`, together with the optional components (`gitHubCli`, `node`, `claudeCode`, `az`). **Read the role from there — never add hostname checks.** chezmoi templates use `.role`; the pre-commit hook reads the toml file; `Scripts/Setup` scripts get `-Role` from their chezmoi trigger.
- **Work overlay**: age-encrypted files (`encrypted_*.age`, key at `~/.config/chezmoi/key.txt`, a copy in Bitwarden), listed in `home/.chezmoiignore` so only the work role gets them, plus the plain-text lists `Config/WinGet/configuration.work.dsc.yaml` and `Config/VisualStudioCode/extensions.work` (only what work has on top of the base). No untracked machine-local files: anything work-only goes in the overlay.
- The work machine's Documents folder is in OneDrive, so never hard-code `Documents\...` — `$PROFILE` is linked at run time by `Scripts/Setup/Set-MachineLinks.ps1`.

## Repo Structure
```
.chezmoiroot           # "home": chezmoi's source state is home/; sourceDir is the repo root (the git working tree)
home/                  # Lands in %USERPROFILE% (dot_ = ".", encrypted_…age = decrypted copy)
  .chezmoi.toml.tmpl   # Per-machine config: role, optional components, mode = "symlink", age, pwsh -NoProfile for scripts
  .chezmoiignore       # Work overlay only for role work
  .chezmoiscripts/     # Thin triggers (run_after_ = every apply, run_onchange_after_ = when a hashed input changes) → Scripts/Setup
  dot_config/git/      # config (shared) + work (includeIf by remote)
  dot_config/powershell/  # user_profile.ps1 (+ autopairing, oh-my-posh/ theme), encrypted_profile.work.ps1.age (overlay)
  dot_claude/settings.json
  AppData/Roaming/Code/User/settings.json            # VS Code
  AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
  AppData/Local/lazygit/config.yml
  AppData/Local/UniGetUI/symlink_Configuration.tmpl  # Directory link → Config/UniGetUI
  encrypted_work.code-workspace.age                  # Overlay: work DB connections (mssql reads them from the open workspace)
Config/                # Data the setup scripts read (not deployed file by file)
  WinGet/              # configuration.dsc.yaml (base) [+ configuration.work.dsc.yaml] — `winget configure`, install-only
  VisualStudioCode/    # extensions (base, full list) + extensions.work (overlay delta), saved by the pre-commit hook
  PowerToys/           # settings.json, applied with PowerToys.DSC.exe
  UniGetUI/            # UniGetUI's Configuration folder (linked as a whole)
Scripts/
  Bootstrap.ps1        # New machine: installs chezmoi, chezmoi init, age key on work, chezmoi apply (Admin, pwsh 7)
  Setup/               # Set-MachineLinks, Install-Packages, Install-PowerShellModules, Install-VsCodeExtensions, Set-PowerToysSettings
  GitHooks/SaveVsCodeExtensions.ps1   # Uses code.cmd (not Code.exe) — see file for why
  WSLSetup.sh          # WSL first-time setup; WSL ~/.gitconfig includes home/dot_config/git/config
.githooks/pre-commit   # Blocks mssql connections in VS Code settings; saves + stages the extension list
.github/workflows/lint.yml  # PS 5.1 parse of GitHooks, PSScriptAnalyzer, JSON parse, chezmoi render (both roles), ShellCheck, leaks + gitleaks
```

## Important Conventions
- **Symlink mode**: plain files in `home/` are symlinked into place, so apps write straight into the repo. Templates (`.tmpl`) and encrypted files are copies — so never make an app-written file a template; put machine differences in the overlay or in a layer the app supports (git includeIf, profile dot-source, VS Code workspace settings).
- **Scripts**: logic in `Scripts/Setup/*.ps1` (linted); the `home/.chezmoiscripts/*.tmpl` files only pass data (`-Role`, switches) and embed `sha256sum` hashes of the inputs that should re-trigger them. A script's non-zero exit makes chezmoi report it and retry on the next apply.
- **Testing chezmoi changes without touching the machine**: `chezmoi status --exclude=scripts` / `chezmoi diff` (read-only; `status` and `verify` always report the `run_after_` scripts, so exclude scripts to check files and links), or isolated: `chezmoi init --source . --config=<tmp>\c.toml --destination=<tmp>\home --persistent-state=<tmp>\s.boltdb --promptBool "<prompt text>=true,..."` then `chezmoi apply --dry-run --exclude=encrypted` with the same flags (what the CI `chezmoi` job does). `--promptBool` keys are the prompt texts, not the data keys; always pass `--no-tty` when running non-interactively, or chezmoi waits for input.
- **Pre-commit hook**: runs in Windows PowerShell 5.1 (via `powershell.exe`), NOT pwsh 7. Avoid PS7-only syntax (e.g. `?.`) and non-ASCII characters (5.1 reads BOM-less files in the system code page) in GitHooks scripts; CI checks both. `Scripts/Setup` and `Bootstrap.ps1` run under pwsh 7.
- **Gitignored UniGetUI files**: `CurrentSessionToken`, `OperationHistory`, `WindowGeometry`, `TelemetryClientToken`, `IpcApiEndpoints/`, `ChangeBackupOutputDirectory` — runtime state; inside the linked folder, gitignored = machine-local. UniGetUI's package backups aren't used: the WinGet lists replace them.
- **mssql connections**: never in the shared VS Code settings (work server names/IPs, public repo). They belong in `~/work.code-workspace` (overlay; save with `chezmoi add --encrypt ~/work.code-workspace`). The pre-commit hook and the `leaks` CI job both catch the key; the CI check also catches private IP addresses anywhere — when mentioning the key in docs, don't write it as a quoted JSON key.
- **Git config**: context-specific settings go in their own file in `home/dot_config/git/`, pulled in by a condition in `config` (work: `includeIf "hasconfig:remote.*.url:https://git.devnet.de/**"` → `work`). Relative include paths resolve next to `~/.config/git/config`, where chezmoi links each file.
- **PowerToys settings** (`Config/PowerToys/settings.json`, keys = `PowerToys.DSC.exe modules --resource settings` names): the `App` entry is merged, so it may be partial; any other module's entry must be the full `settings` object from `PowerToys.DSC.exe get --module <Name> --resource settings` (compared and replaced as a whole). PowerToys' PowerShell DSC module is broken in 0.101 (compares DisplayVersion `0.101.2362` to the registry's `0.101.2362.0`), so it isn't used from the WinGet list.
- **PowerShell modules**: PSResourceGet (`Install-PSResource`, `Get-InstalledPSResource`), not PowerShellGet v2 — `Get-InstalledModule` misses versions it didn't install itself. Updates come from UniGetUI; the setup only installs missing ones and removes superseded versions.
- **Profile startup is tuned** (see comments in `user_profile.ps1`): nothing before the first prompt may use cmdlets from Microsoft.PowerShell.Management/Utility (`Get-Item`, `Test-Path`, `Set-Alias`, `Register-EngineEvent`, ...) — use .NET/engine APIs instead; modules load lazily on first use; oh-my-posh/zoxide init scripts are cached and patched in `%LOCALAPPDATA%\PowerShellProfileCache` (bump the `v4` cache key after changing a `$Generate` block). Never set `Set-PSReadLineOption -EditMode` below custom key bindings — it resets them. The profile finds its companion files through its resolved link target (`$global:DotfilesConfig` = `home/dot_config/powershell`).
- **User PATH edits**: `HKCU:\Environment\Path` is `REG_EXPAND_SZ` and contains `%USERPROFILE%`, `%NVM_HOME%` and `%NVM_SYMLINK%` tokens. Write it with `Set-ItemProperty -Type ExpandString` and read it with `GetValue('Path','','DoNotExpandEnvironmentNames')`. `[Environment]::SetEnvironmentVariable(...,'User')` expands those tokens and bakes them out permanently, breaking the nvm indirection.

## Common Tasks
- **Sync configs**: commit what the apps changed (they write through the symlinks); `chezmoi update` on the other machine
- **New machine**: clone → `pwsh -NoProfile -File Scripts/Bootstrap.ps1` (Admin, pwsh 7)
- **Add a config file**: put it in `home/` at its target path with chezmoi names (or `chezmoi add <target>`), then `chezmoi apply`
- **Add a tool**: a `Microsoft.WinGet.DSC/WinGetPackage` entry in `Config/WinGet/configuration.dsc.yaml` (work-only: `configuration.work.dsc.yaml`); check with `winget configure validate` / `winget configure test --file ...` (read-only)
- **Work-only profile code**: `chezmoi edit ~/.config/powershell/profile.work.ps1` (needs the age key)
- **Change a PowerToys setting for all machines**: edit `Config/PowerToys/settings.json` (see the convention above)
- **Add a new PS alias**: add a `${alias:name} = 'target'` line to the `#Alias` section in `home/dot_config/powershell/user_profile.ps1` (not `Set-Alias` — it loads the Utility module at startup)

## Installed Tools
winget configure (`Config/WinGet/configuration.dsc.yaml`, install-only, updates come from UniGetUI): PowerToys, fzf, Windows Terminal, Oh My Posh, PowerShell 7, UniGetUI (`Devolutions.UniGetUI`), Git, Bitwarden (app + CLI), VS Code, lazygit, nvm-windows, zoxide, chezmoi; Developer Mode
font: JetBrainsMono Nerd Font (via `oh-my-posh font install`, skipped when installed)
PS modules (PSResourceGet): PSFzf, CompletionPredictor, posh-git, Terminal-Icons
optional (asked once by `chezmoi init`, stored in its config): GitHub CLI, Node.js LTS via nvm, Claude Code CLI (native installer → `%USERPROFILE%\.local\bin\claude.exe`, folder added to the User PATH), Az modules
