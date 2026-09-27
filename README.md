# Dotfiles

Windows dotfiles and machine setup for two machines, managed with [chezmoi](https://www.chezmoi.io/): PowerShell profile, Windows Terminal, VS Code, Git, lazygit, Claude Code, UniGetUI and PowerToys, plus the packages, modules and extensions that go with them.

## How It Works

- **One base, one overlay.** Everything in `home/` is the base setup, the private machine's. A machine with the **work** role also gets the work overlay: files encrypted with [age](https://age-encryption.org/), so this public repo shows nothing of them, plus its own package and extension lists.
- **The role is set once per machine.** `chezmoi init` stores it in `~/.config/chezmoi/chezmoi.toml`, along with the answers about optional components. Machines named `DEV-WNW-*` start out as work, every other machine as private. `chezmoi edit-config` changes it.
- **On Windows, configs are symlinks into the repo** (chezmoi's symlink mode). When an app changes its own settings, the change is already in the repo; commit it. Only templates (like git's per-OS `os` file) and the encrypted overlay files are copies.
- **WSL uses the same repo.** chezmoi in WSL runs from the Windows clone and takes the parts that make sense there, as copies (see [WSL Setup](#wsl-setup)).
- **Setup scripts run from `chezmoi apply`.** `home/.chezmoiscripts/` says when a script runs: every apply, or when something it depends on changes. `Scripts/Setup/` holds what the script does, where CI can lint it.

## Repo Layout

| Path | What it is |
|------|-----------|
| `.chezmoiroot` | Makes `home/` chezmoi's source; the repo root is the git working tree |
| `home/` | chezmoi's source: each file lands at the same path under `%USERPROFILE%` (`dot_config` is `.config`, `encrypted_*.age` is the decrypted copy) |
| `home/.chezmoi.toml.tmpl` | The per-machine config: role, optional components, symlink mode, age encryption, `pwsh -NoProfile` for scripts |
| `home/.chezmoiignore` | Leaves the work overlay out unless the role is work, and gives WSL only what applies there |
| `home/.chezmoiscripts/` | When the setup scripts run: thin triggers that pass data and hash the files that should re-run them |
| `Config/` | Data rather than files chezmoi places one by one: WinGet package lists, VS Code extension lists, PowerToys settings, the passphrase-encrypted age key, and the folders linked as a whole (UniGetUI's configuration, Claude Code's settings) |
| `Scripts/Setup/` | The setup scripts |
| `Scripts/Bootstrap.ps1` | First-time setup of a new machine |
| `Scripts/Test-Bootstrap.ps1` | Tries the bootstrap on a clean, throwaway Windows in Windows Sandbox |
| `.githooks/`, `Scripts/GitHooks/` | The pre-commit hook |
| `Scripts/WSLSetup.sh` | WSL first-time setup: installs chezmoi there and runs it from this clone |

## New Machine

Prerequisites: [Git](https://git-scm.com/), [winget](https://learn.microsoft.com/en-us/windows/package-manager/) (built into Windows 11) and [PowerShell 7](https://github.com/PowerShell/PowerShell) (`winget install Microsoft.PowerShell`). On a work machine, have the age key's passphrase from Bitwarden at hand.

```powershell
# 1. Clone the repo (any location works)
git clone https://github.com/Layfully/Dotfiles "$env:USERPROFILE\Dotfiles"
cd "$env:USERPROFILE\Dotfiles"

# 2. Run the bootstrap as Administrator (it relaunches itself elevated if needed)
pwsh -NoProfile -File Scripts/Bootstrap.ps1
```

The bootstrap installs chezmoi, runs `chezmoi init`, decrypts the age key on a work machine (it asks for the passphrase), and runs `chezmoi apply`. Elevated, the setup scripts run without UAC prompts. chezmoi asks once about the optional components (GitHub CLI, Node.js LTS through nvm, Claude Code CLI, Az modules, JetBrains Rider). To answer ahead of time, pass switches: `-GitHubCli -Node:$false -ClaudeCode -Az:$false -Rider:$false`. The one per-user tool downloaded and run as a script, the Claude Code installer, runs with your normal rights even then.

To try the bootstrap without a spare machine, `pwsh -NoProfile -File Scripts/Test-Bootstrap.ps1 -Wait` runs it in Windows Sandbox: a clean, throwaway Windows that gets winget, PowerShell 7 and Git first, then clones the repo's last commit and bootstraps it as a private machine. It needs the Windows Sandbox feature (the script says how to turn it on).

## Day to Day

| To... | Do |
|-------|----|
| Keep a setting you changed in an app | Nothing to copy, it's already in the repo: commit it |
| Get what the other machine committed | `chezmoi update` (git pull, then apply) |
| See whether this machine matches the repo | `chezmoi status --exclude=scripts` (empty = in sync), `chezmoi verify --exclude=scripts`. Without `--exclude=scripts` both always list the every-apply script (`10-machine-links`) |
| Add a config file | Put it in `home/` at its target path with chezmoi names (or `chezmoi add <target>`), then `chezmoi apply` |
| Change the role or an optional component | `chezmoi edit-config`, then `chezmoi apply` |
| Add a package every machine gets | A `Microsoft.WinGet.DSC/WinGetPackage` entry in `Config/WinGet/configuration.dsc.yaml` |
| Add a package only work machines get | The same, in `Config/WinGet/configuration.work.dsc.yaml` (create it the first time) |
| Edit the work profile overlay | `chezmoi edit ~/.config/powershell/profile.work.ps1` (on a machine with the age key) |
| See the shell shortcuts | `cheat` in PowerShell (defined in `home/dot_config/powershell/user_profile.ps1`) |

`winget configure test --file <list>` shows what a package list would change, without changing anything.

## What Gets Linked

| Location | Source in the repo |
|----------|-------------------|
| `$PROFILE` | A one-line stub that loads `~/.config/powershell/user_profile.ps1`, which links to `home/dot_config/powershell/user_profile.ps1` |
| `~/.config/git/config`, `work` (`os` is a per-OS copy) | `home/dot_config/git/` (see [Git Config](#git-config)) |
| `~/.config/oh-my-posh/cloud-context.omp.json` | `home/dot_config/oh-my-posh/`: the prompt theme, used by pwsh and by bash in WSL |
| `%APPDATA%\Code\User\settings.json` | `home/AppData/Roaming/Code/User/settings.json` |
| `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_...\LocalState\settings.json` | `home/AppData/Local/Packages/.../settings.json` |
| `%LOCALAPPDATA%\lazygit\config.yml` | `home/AppData/Local/lazygit/config.yml` |
| `~/.claude/settings.json` | `Config/Claude/settings.json`, through a symlink entry (`home/dot_claude/symlink_settings.json.tmpl`), so it stays a link in WSL too |
| `%LOCALAPPDATA%\UniGetUI\Configuration` | `Config/UniGetUI/`: the whole folder, because UniGetUI turns some settings off by deleting a file. Its runtime state is gitignored, so it stays on each machine |

`$PROFILE` gets a stub from `Scripts/Setup/Set-MachineLinks.ps1`, not a link from chezmoi: OneDrive moves `Documents` on the work machine, so the profile's path is only known at run time, and OneDrive handles symlinks badly.

## Setup Scripts

| Script | Runs | What it does |
|--------|------|-------------|
| `Set-MachineLinks.ps1` | Every apply | Writes the `$PROFILE` stub, enables the git hooks, and moves aside a `~/.gitconfig` (git reads it ahead of `~/.config/git`) |
| `Install-Packages.ps1` | When a package list or an optional component changes | `winget configure` with the base list (and the work list on work machines): installs what is missing and turns on Developer Mode. Nothing is upgraded, UniGetUI does that. Also the optional components and the JetBrainsMono Nerd Font |
| `Install-PowerShellModules.ps1` | When it or `-Az` changes, and once a week | Installs missing modules (PSFzf, CompletionPredictor, posh-git, Terminal-Icons, optionally Az) through PSResourceGet, and removes the older versions UniGetUI's updates leave behind |
| `Install-VsCodeExtensions.ps1` | When an extension list changes | Installs what is missing from `Config/VisualStudioCode/extensions`, plus `extensions.work` on work machines |
| `Set-PowerToysSettings.ps1` | When `Config/PowerToys/settings.json` changes | See [PowerToys Settings](#powertoys-settings) |
| `install-wsl-packages.sh` | In WSL, when it changes | See [WSL Setup](#wsl-setup) |

A script that fails makes `chezmoi apply` report it, and it runs again on the next apply.

## The Work Overlay

| File | Lands at | What it holds |
|------|----------|---------------|
| `home/dot_config/powershell/encrypted_profile.work.ps1.age` | `~/.config/powershell/profile.work.ps1` | Work-only profile code; the profile dot-sources it last |
| `home/encrypted_work.code-workspace.age` | `~/work.code-workspace` | The work database connections and their connection groups. The mssql extension reads them from the open workspace |
| `Config/WinGet/configuration.work.dsc.yaml` | — | Packages only work machines get (plain text) |
| `Config/VisualStudioCode/extensions.work` | — | Extensions the work machine has on top of the base list (plain text) |

The age key is at `~/.config/chezmoi/key.txt`. The repo holds it encrypted with a passphrase, kept in Bitwarden, as `Config/age/key.txt.age`; the bootstrap decrypts it on a work machine. The private machine applies nothing encrypted, so it only needs the key to edit the overlay. After changing `~/work.code-workspace`, save it back with `chezmoi add --encrypt ~/work.code-workspace`.

## Git Config

Git reads `~/.config/git/config`. Settings for one context live in their own file, included by a condition:

| File | Applies to |
|------|-----------|
| `home/dot_config/git/config` | Everything: personal identity and shared settings |
| `home/dot_config/git/os.tmpl` | This OS only, rendered by chezmoi: `fsmonitor` on Windows; in WSL, Windows' Git Credential Manager |
| `home/dot_config/git/work` | Repositories with a remote on `git.devnet.de` (`includeIf "hasconfig:remote.*.url:..."`): work email and credential settings, on either machine, and already while cloning one |

Remote-based conditions need git 2.36 or later.

The shared settings are chosen with lazygit in mind:
- pulling rebases instead of merging, and stashes uncommitted changes around the rebase;
- branches stacked on a rebased one move along with it;
- rerere remembers conflict resolutions;
- conflict markers include the common ancestor (`zdiff3`);
- lazygit's external merge tool (`M` on a conflicted file) and `git difftool` open VS Code;
- a new branch's first push sets its upstream.

Diffs go through [delta](https://github.com/dandavison/delta), with syntax highlighting: git's pager (`git diff`, `git show`, `git log -p`, `git add -p`; `n`/`N` jump between files) and lazygit, where `|` cycles to delta side by side and to git's own diff.

## PowerToys Settings

`Config/PowerToys/settings.json` maps a module name (as `PowerToys.DSC.exe modules --resource settings` lists them) to the settings it should have. `Set-PowerToysSettings.ps1` applies each one with `PowerToys.DSC.exe set`:

- `App` holds the general settings and which modules are on (`enabled`). PowerToys merges it into what is there, so it can list just the settings that matter.
- Any other module is compared and replaced as a whole, so add it as the complete `settings` object printed by `PowerToys.DSC.exe get --module <Name> --resource settings`.

`PowerToys.DSC.exe` sits in the PowerToys install folder (`%LOCALAPPDATA%\PowerToys` for a per-user install). PowerToys' PowerShell DSC module, the one `winget configure` could use, fails to find the installation in PowerToys 0.101, which is why these settings aren't in the WinGet package list.

## Git Hooks

The pre-commit hook:

- refuses a commit whose staged VS Code settings contain work database connections (the mssql extension saves new ones there), and says how to move them into the work overlay;
- on Windows (not for commits made from WSL), runs `SaveVsCodeExtensions.ps1`, which saves the installed VS Code extensions: the full list to `extensions` on the private machine, or just what's on top of that list to `extensions.work` on a work machine. The role comes from chezmoi's config.

`Set-MachineLinks.ps1` enables the hook. It runs under Windows PowerShell 5.1, so `Scripts/GitHooks/*.ps1` must avoid PowerShell 7-only syntax and non-ASCII characters.

## WSL Setup

After running `wsl --install` and launching Ubuntu:

```bash
# The Windows clone is under /mnt/c; adjust the path if you cloned elsewhere
bash "$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")/Dotfiles/Scripts/WSLSetup.sh"
```

The script installs chezmoi in WSL and runs it from the Windows clone. WSL gets the git config (with its own `os` file), the prompt theme, Claude Code's settings and a bash setup: `~/.config/bash/dotfiles.sh` loads oh-my-posh, zoxide and fzf's key bindings, and sets the same short git aliases as the profile. Its one WSL-only script installs fzf, zoxide, delta and oh-my-posh, and adds a line to `~/.bashrc` that loads `dotfiles.sh`; Ubuntu's own `.bashrc` stays otherwise untouched. It also removes the git settings earlier versions of the script wrote to `~/.gitconfig`.

In WSL the files are copies, not links: reading a file under `/mnt/c` is slow, and git read its config there on every command (about 45 ms each, against 4 ms for a local copy). Only Claude Code's settings stay a link. Afterwards, `chezmoi update` in WSL keeps it in sync, as on Windows.

## Linting

`.github/workflows/lint.yml` runs on every push to `main` and on pull requests. Its token is read-only, the actions are pinned to commit SHAs, and checkouts don't keep the token. Dependabot (`.github/dependabot.yml`) opens a weekly pull request when an action has a new version, and updates the pin. chezmoi and PSScriptAnalyzer are pinned in the workflow too (chezmoi with its release checksums); those are bumped by hand.

| Job | What it checks |
|-----|---------------|
| `powershell` | Parses the hook scripts with Windows PowerShell 5.1, runs PSScriptAnalyzer over every `.ps1` (rules in `PSScriptAnalyzerSettings.psd1`, which the VS Code PowerShell extension reads too), parses every tracked `.json` (VS Code's and Windows Terminal's settings may have comments and trailing commas), and runs `winget configure validate` on the WinGet lists |
| `chezmoi` | Renders every template (config, ignore rules, links, scripts) for both roles, on Windows and on Linux (as in WSL), without running anything or needing the age key |
| `shell` | ShellCheck on the bash scripts and `.githooks/pre-commit` |
| `leaks` | Fails on work infrastructure in this public repo (a VS Code mssql connections key, private network addresses), reporting only file and line; gitleaks scans the pushed commits for secrets |
