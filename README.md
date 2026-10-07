# Dotfiles

Windows dotfiles and machine setup for two machines, managed with [chezmoi](https://www.chezmoi.io/): PowerShell profile, Windows Terminal, VS Code, Git, lazygit, Claude Code, UniGetUI and PowerToys, plus the packages and modules that go with them.

## How It Works

- **One base, one overlay.** Everything in `home/` is the base setup, the private machine's. A machine with the **work** role also gets the work overlay: files encrypted with [age](https://age-encryption.org/), so this public repo shows nothing of them, plus its own package list.
- **The role is chosen once per machine.** The first `chezmoi init` asks for it (`private` or `work`, `private` by default) and stores it in `~/.config/chezmoi/chezmoi.toml`, along with the Dev Drive for the package caches. `chezmoi edit-config` changes them. What a machine installs follows from its role: the base package list, plus the role's own.
- **On Windows, configs are symlinks into the repo** (chezmoi's symlink mode). When an app changes its own settings, the change is already in the repo; commit it. Only templates (like git's per-OS `os` file) and the encrypted overlay files are copies.
- **WSL uses the same repo.** chezmoi in WSL runs from the Windows clone and takes the parts that make sense there, as copies (see [WSL Setup](#wsl-setup)).
- **Setup scripts run from `chezmoi apply`.** `home/.chezmoiscripts/` says when a script runs: every apply, or when something it depends on changes. `Scripts/Setup/` holds what the script does, where CI can lint it.

## Repo Layout

| Path | What it is |
|------|-----------|
| `.chezmoiroot` | Makes `home/` chezmoi's source; the repo root is the git working tree |
| `home/` | chezmoi's source: each file lands at the same path under `%USERPROFILE%` (`dot_config` is `.config`, `encrypted_*.age` is the decrypted copy) |
| `home/.chezmoi.toml.tmpl` | The per-machine config: role, Dev Drive, symlink mode, age encryption, `pwsh -NoProfile` for scripts |
| `home/.chezmoiignore` | Leaves the work overlay out unless the role is work, and gives WSL only what applies there |
| `home/.chezmoiscripts/` | When the setup scripts run: thin triggers that pass data and hash the files that should re-run them |
| `Config/` | Data rather than files chezmoi places one by one: WinGet package lists, the work machine's Visual Studio workloads and Docker Desktop settings, PowerToys settings, the passphrase-encrypted age key, UniGetUI's configuration (a folder linked as a whole), and Claude Code's settings and user instructions |
| `Scripts/Setup/` | The setup scripts |
| `Scripts/Bootstrap.ps1` | First-time setup of a new machine |
| `Scripts/Test-Bootstrap.ps1` | Tries the bootstrap on a clean, throwaway Windows in Windows Sandbox |
| `.githooks/` | The pre-commit hook |
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

The bootstrap installs chezmoi, runs `chezmoi init`, decrypts the age key on a work machine (it asks for the passphrase), and runs `chezmoi apply`. Elevated, the setup scripts run without UAC prompts. chezmoi asks once for the machine's role and for a Dev Drive for the package caches. To answer ahead of time, pass them: `-Role work -DevDrive D:` (`-DevDrive none` for no Dev Drive).

To try the bootstrap without a spare machine, `pwsh -NoProfile -File Scripts/Test-Bootstrap.ps1 -Wait` runs it in Windows Sandbox: a clean, throwaway Windows that gets winget, PowerShell 7 and Git first, then clones the repo's last commit and bootstraps it as a private machine. It needs the Windows Sandbox feature (the script says how to turn it on).

## Day to Day

| To... | Do |
|-------|----|
| Keep a setting you changed in an app | Nothing to copy, it's already in the repo: commit it |
| Get what the other machine committed | `chezmoi update` (git pull, then apply) |
| See whether this machine matches the repo | `chezmoi status --exclude=scripts` (empty = in sync), `chezmoi verify --exclude=scripts`. Without `--exclude=scripts` both always list the every-apply scripts (`10-machine-links`, `25-dev-drive`) |
| Add a config file | Put it in `home/` at its target path with chezmoi names (or `chezmoi add <target>`), then `chezmoi apply` |
| Change the role or the Dev Drive | `chezmoi edit-config`, then `chezmoi apply` |
| Add a package every machine gets | A `Microsoft.WinGet.DSC/WinGetPackage` entry in `Config/WinGet/configuration.dsc.yaml`, and an update source in UniGetUI (see [Package Updates](#package-updates)) |
| Add a package only one role gets | The same, in `Config/WinGet/configuration.private.dsc.yaml` or `configuration.work.dsc.yaml` |
| Add a VS Code extension both machines get | Install it, then right-click it > Apply Extension to all Profiles (see [VS Code Extensions](#vs-code-extensions)) |
| Add a VS Code extension only work machines get | Install it in the Work profile |
| Keep a Docker Desktop setting on work machines | Set it in `Config/Docker/settings.json`, quit Docker Desktop, then `chezmoi apply` (see [Docker Desktop Settings](#docker-desktop-settings)) |
| Change the work machine's Visual Studio workloads | Modify the installation in the Visual Studio Installer, then More > Export configuration over `Config/VisualStudio/work.vsconfig` |
| Keep a package updated on every machine | Mark it for automatic updates in UniGetUI, then commit `Config/UniGetUI` (see [Package Updates](#package-updates)) |
| Hold a package back | Ignore its updates (or one version) in UniGetUI, then commit `Config/UniGetUI` |
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
| `%LOCALAPPDATA%\Microsoft\PowerToys\FancyZones\custom-layouts.json` | `home/AppData/Local/Microsoft/PowerToys/FancyZones/custom-layouts.json`: the FancyZones layouts (the other PowerToys settings are applied, see [PowerToys Settings](#powertoys-settings)) |
| `~/.claude/settings.json` | `Config/Claude/settings.json`, through a symlink entry (`home/dot_claude/symlink_settings.json.tmpl`), so it stays a link in WSL too |
| `~/.claude/CLAUDE.md` | `Config/Claude/CLAUDE.md`: what Claude Code should know about me and these machines in every project, linked the same way. On a work machine it imports `~/.claude/CLAUDE.work.md` from the work overlay |
| `%LOCALAPPDATA%\UniGetUI\Configuration` | `Config/UniGetUI/`: the whole folder, because UniGetUI turns some settings off by deleting a file. `.gitignore` lists the settings that are shared; the runtime state UniGetUI keeps there stays on each machine |

`$PROFILE` gets a stub from `Scripts/Setup/Set-MachineLinks.ps1`, not a link from chezmoi: OneDrive moves `Documents` on the work machine, so the profile's path is only known at run time, and OneDrive handles symlinks badly.

## Setup Scripts

| Script | Runs | What it does |
|--------|------|-------------|
| `Set-MachineLinks.ps1` | Every apply | Writes the `$PROFILE` stub and enables the git hooks |
| `Install-Packages.ps1` | When it or one of its package lists changes | `winget configure` with the base list and the role's list (on work machines with Visual Studio and the workloads in `Config/VisualStudio/work.vsconfig`; those ask for UAC unless the apply runs elevated): installs what is missing and turns on Developer Mode. Nothing is upgraded, UniGetUI does that. Also the latest Node.js LTS through nvm where a list has nvm, and the JetBrainsMono Nerd Font |
| `Set-DevDriveCaches.ps1` | Every apply (it only changes something when the variables don't match the answer) | Points the NuGet and npm caches (`NUGET_PACKAGES`, `npm_config_cache`) at `<drive>\packages` on the Dev Drive. User environment variables, so they hold for every Node version nvm switches to. With no Dev Drive (`none`), it removes them again |
| `Install-PowerShellModules.ps1` | When it changes, and once a week | Installs missing modules (PSFzf, CompletionPredictor, posh-git, Terminal-Icons) through PSResourceGet, and removes the older versions UniGetUI's updates leave behind |
| `Set-PowerToysSettings.ps1` | When it or `Config/PowerToys/settings.json` changes | See [PowerToys Settings](#powertoys-settings) |
| `Set-DockerSettings.ps1` | On work machines, when it or `Config/Docker/settings.json` changes | See [Docker Desktop Settings](#docker-desktop-settings) |
| `install-wsl-packages.sh` | In WSL, when it changes | See [WSL Setup](#wsl-setup) |

A script that fails makes `chezmoi apply` report it, and it runs again on the next apply.

## Package Updates

The WinGet lists only say which packages a machine has. Each machine's UniGetUI updates them, following settings that live in the linked `Config/UniGetUI/` folder, so a change made on one machine reaches the other with the next `chezmoi update`:

- `AutomaticallyUpdatePackages` turns automatic updates on, and `MaintenanceSchedules` says when they are installed. Set to `MarkedPackagesOnly`, they cover only the packages listed in `AutoUpdatedPackages.json` (marked per package in UniGetUI).
- `IgnoredPackageUpdates.json` holds the packages kept back: `*` ignores every update, a version number skips that one.

Every package in a WinGet list needs one of the two, decided when it is added: marked for automatic updates, or, for an app that updates itself (VS Code, Spotify, Teams, ...), its updates ignored with `*`, so the two updaters don't fight. CI fails on a listed package that is in neither file.

No version is copied from one machine to the other: each machine installs the same updates on its own schedule. A package that has to stay at one exact version gets a `version` setting on its WinGet list entry, and a matching hold in UniGetUI so the two don't fight.

## The Work Overlay

| File | Lands at | What it holds |
|------|----------|---------------|
| `home/dot_config/powershell/encrypted_profile.work.ps1.age` | `~/.config/powershell/profile.work.ps1` | Work-only profile code; the profile dot-sources it last |
| `home/encrypted_work.code-workspace.age` | `~/work.code-workspace` | The work database connections and their connection groups. The mssql extension reads them from the open workspace |
| `home/dot_claude/encrypted_CLAUDE.work.md.age` | `~/.claude/CLAUDE.work.md` | The work part of Claude Code's user instructions. After changing it: `chezmoi add --encrypt ~/.claude/CLAUDE.work.md` |
| `Config/WinGet/configuration.work.dsc.yaml` | — | Packages only work machines get (plain text) |
| `Config/VisualStudio/work.vsconfig` | — | The Visual Studio workloads and components the work list installs (plain text) |
| `Config/Docker/settings.json` | — | The Docker Desktop settings work machines get (plain text, see [Docker Desktop Settings](#docker-desktop-settings)) |

The age key is at `~/.config/chezmoi/key.txt`. The repo holds it encrypted with a passphrase, kept in Bitwarden, as `Config/age/key.txt.age`; the bootstrap decrypts it on a work machine. The private machine applies nothing encrypted, so it only needs the key to edit the overlay. After changing `~/work.code-workspace`, save it back with `chezmoi add --encrypt ~/work.code-workspace`.

## Git Config

Git reads `~/.config/git/config`. Settings for one context live in their own file, included by a condition:

| File | Applies to |
|------|-----------|
| `home/dot_config/git/config` | Everything: personal identity and shared settings |
| `home/dot_config/git/os.tmpl` | This OS only, rendered by chezmoi: `fsmonitor` on Windows; in WSL, Windows' Git Credential Manager |
| `home/dot_config/git/work` | Work repositories, recognised by their remote: `git.devnet.de` or Azure DevOps (`includeIf "hasconfig:remote.*.url:..."`): work email and credential settings, on either machine, and already while cloning one |
| `~/.gitconfig` (`home/create_dot_gitconfig`) | This machine only: chezmoi creates it once, empty, and never changes it |

Remote-based conditions need git 2.36 or later.

`git config --global` writes to `~/.gitconfig`, so what tools save for one machine (`gh auth setup-git`'s credential helper, Git LFS, an IDE's merge tool) stays there instead of going into the shared, public config. Git reads it last, so it overrides the shared settings on that machine. A setting every machine should have goes in `home/dot_config/git/config` by hand.

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

`PowerToys.DSC.exe` sits in the PowerToys install folder (`%LOCALAPPDATA%\PowerToys` for a per-user install). PowerToys' PowerShell DSC module, the one `winget configure` could use, fails to find the installation in PowerToys 0.101 (it compares the DisplayVersion `0.101.2362` with the registry's `0.101.2362.0`), which is why these settings aren't in the WinGet package list.

## Docker Desktop Settings

`Config/Docker/settings.json` holds the Docker Desktop settings chosen on purpose (updates off for UniGetUI, the Docker VMM engine and its memory, notifications, beta features). `Set-DockerSettings.ps1` sets each of them in Docker's `%APPDATA%\Docker\settings-store.json` and leaves the rest of that file alone: Docker's own bookkeeping, and the license and welcome screens a new install should still show.

The file isn't linked: Docker saves by replacing it, which would turn a link back into a plain file. So a setting changed in Docker's settings window stays on the machine until it is copied into `Config/Docker/settings.json`.

Docker writes its settings back when it quits, so the script changes nothing while Docker Desktop is running, and nothing before Docker has started once and created the file. Either way it fails, and the next `chezmoi apply` tries again: quit Docker Desktop first.

## VS Code Extensions

The extensions aren't in the repo: VS Code's Settings Sync carries them (**Settings Sync: Configure…**: everything but **Settings**, which is the repo's `settings.json`). It installs and removes them on both machines, and a new machine gets them after signing in to Sync.

- The **Default** profile is the private machine's.
- The **Work** profile is the work machine's. It is a duplicate of the Default profile with **Use Default profile** set for everything but **Extensions**, so its settings, keyboard shortcuts, snippets and tasks come from the Default profile, and only its extensions differ: the work-only ones are installed in it.
- Each work folder is switched to the Work profile once (**Profiles: Switch Profile**); VS Code remembers it per folder. Not **Use for New Windows**: that writes `window.newWindowProfile` into the shared `settings.json`, and Sync gives the private machine the Work profile too.
- An extension both machines should get is marked **Apply Extension to all Profiles** (Extensions view, one at a time); one installed without that lands only in the profile that is open.

## Git Hooks

The pre-commit hook refuses a commit whose staged VS Code settings contain work database connections (the mssql extension saves new ones there), and says how to move them into the work overlay. `Set-MachineLinks.ps1` enables it.

## WSL Setup

After running `wsl --install` and launching Ubuntu:

```bash
# The Windows clone is under /mnt/c; adjust the path if you cloned elsewhere
bash "$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")/Dotfiles/Scripts/WSLSetup.sh"
```

The script installs chezmoi in WSL and runs it from the Windows clone. WSL gets the git config (with its own `os` file), the prompt theme, Claude Code's settings and CLAUDE.md, and a bash setup: `~/.config/bash/dotfiles.sh` loads oh-my-posh, zoxide and fzf's key bindings, and sets the same short git aliases as the profile. Its one WSL-only script installs fzf, zoxide, delta and oh-my-posh, and adds a line to `~/.bashrc` that loads `dotfiles.sh`; Ubuntu's own `.bashrc` stays otherwise untouched. `wsl` starts a login shell, which reads `~/.bash_profile` instead of `~/.profile` (what loads `~/.bashrc` on Ubuntu): chezmoi creates a `~/.bash_profile` that loads `~/.profile`, and the script adds that line to one that already existed (the .NET SDK creates one).

In WSL the files are copies, not links: reading a file under `/mnt/c` is slow, and git read its config there on every command (about 45 ms each, against 4 ms for a local copy). Only Claude Code's settings and CLAUDE.md stay links. Afterwards, `chezmoi update` in WSL keeps it in sync, as on Windows.

## Linting

`.github/workflows/lint.yml` runs on every push to `main` and on pull requests. Its token is read-only, the actions are pinned to commit SHAs, and checkouts don't keep the token. Dependabot (`.github/dependabot.yml`) opens a weekly pull request when an action has a new version, and updates the pin. chezmoi and PSScriptAnalyzer are pinned in the workflow too (chezmoi with its release checksums, the same pin `Scripts/WSLSetup.sh` installs); those are bumped by hand.

| Job | What it checks |
|-----|---------------|
| `powershell` | Runs PSScriptAnalyzer over every `.ps1` (rules in `PSScriptAnalyzerSettings.psd1`, which the VS Code PowerShell extension reads too), parses every tracked `.json` (VS Code's and Windows Terminal's settings may have comments and trailing commas), checks that every listed package has an update source in UniGetUI (see [Package Updates](#package-updates)), and runs `winget configure validate` on the WinGet lists |
| `chezmoi` | Renders every template (config, ignore rules, links, scripts) for both roles, one with a Dev Drive and one without, on Windows and on Linux (as in WSL), without running anything or needing the age key |
| `shell` | ShellCheck on the bash scripts and `.githooks/pre-commit` |
| `leaks` | Fails on work infrastructure in this public repo (VS Code mssql connections or connection groups, private network addresses: IPv4, the 100.64/10 range VPNs use, and IPv6 unique local ones), reporting only file and line; a failing search fails the job instead of passing it; gitleaks scans the pushed commits for secrets |
