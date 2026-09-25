<#
.SYNOPSIS
Sets up this machine: tools, PowerShell modules and the config symlinks.

.DESCRIPTION
Each optional component has a switch: pass it to install the component (-Node), or pass it as
:$false to skip it (-Node:$false). Components left out are asked about once, before anything is
installed, so the rest of the run needs no input.

.EXAMPLE
pwsh -NoProfile -File Scripts/Tools.ps1 -GitHubCli -Node -Claude -Az:$false
#>
param(
    [switch]$GitHubCli,  # GitHub CLI
    [switch]$Node,       # latest Node.js LTS via nvm
    [switch]$Claude,     # Claude Code CLI (native build)
    [switch]$Az          # Az PowerShell modules
)

$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
$commandLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $PID").CommandLine
$isNoProfile = $commandLine -like '*-NoProfile*'

if (-not $isAdministrator -or -not $isNoProfile) {
    $relaunchReason = if (-not $isAdministrator) { "Administrator privileges are required." } else { "A clean, no-profile session is required." }
    Write-Warning "$relaunchReason Attempting to relaunch correctly..."

    # Forward the switches as -Name:True / -Name:False, which pwsh -File binds back to the switch.
    # Start-Process joins -ArgumentList with spaces and does not quote, so the script path is quoted by hand.
    $forwardedArguments = $PSBoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key):$([bool]$_.Value)" }
    Start-Process -Verb RunAs wt -ArgumentList (@("pwsh.exe", "-NoProfile", "-File", "`"$PSCommandPath`"") + $forwardedArguments)
    Exit # Exit the current, incorrect session.
}

Write-Host "Script is running correctly (Administrator + No Profile)." -ForegroundColor Green

# The repo root is the parent of Scripts\, so the clone works from any location
$repoRoot = Split-Path -Path $PSScriptRoot -Parent

# Reloads PATH from the registry, so tools installed during this run can be found without a new session
function Sync-SessionPath {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

$otherPwshProcesses = Get-Process -Name pwsh -ErrorAction SilentlyContinue | Where-Object { $_.Id -ne $PID }

if ($otherPwshProcesses) {
    Write-Warning "For a safe installation, all other PowerShell sessions must be closed to prevent file locks."
    Write-Host "The following PowerShell processes were found:" -ForegroundColor Yellow
    $otherPwshProcesses | Format-Table Id, ProcessName, MainWindowTitle -AutoSize
    # Processes without a window title are usually hosted by other apps, not terminals the user opened
    Write-Warning ("This includes processes without a window, such as VS Code's PowerShell extension and the shells " +
        "of Claude Code or other tools - closing them breaks those until they are restarted.")

    $confirmation = Read-Host -Prompt "Do you want to automatically close these sessions? (Y/N)"
    if ($confirmation -match "^y(es)?$") {
        Write-Host "Closing other PowerShell processes..."
        $otherPwshProcesses | ForEach-Object {
            Write-Host "Stopping process with ID: $($_.Id)..."
            Stop-Process -Id $_.Id -Force
        }
        Write-Host "All other PowerShell sessions have been closed." -ForegroundColor Green
    }
    else {
        Write-Error "User aborted. The script cannot continue safely while other PowerShell sessions are running."
        Read-Host -Prompt "Press Enter to exit..."
        Exit
    }
}
else {
    Write-Host "No other PowerShell instances found. Environment is clean." -ForegroundColor Green
}

#--- Optional components ---
# Everything not decided by a switch is asked here, before anything is installed, so the run needs no input after this
$optionalComponents = [ordered]@{
    GitHubCli = "GitHub CLI"
    Node      = "the latest Node.js LTS via nvm"
    Claude    = "the Claude Code CLI"
    Az        = "the Az PowerShell modules"
}
$install = @{}
foreach ($componentName in $optionalComponents.Keys) {
    $install[$componentName] = if ($PSBoundParameters.ContainsKey($componentName)) {
        [bool]$PSBoundParameters[$componentName]
    }
    else {
        (Read-Host -Prompt "Do you want to install $($optionalComponents[$componentName])? (Y/N)") -match "^y(es)?$"
    }
}

#--- Tool Installation and Upgrade ---
Write-Host "Ensuring essential tools are installed and up-to-date..."

# Use a list for easier management and iteration
$wingetPackages = @(
    "Microsoft.PowerToys"
    "junegunn.fzf"
    "Microsoft.WindowsTerminal"
    "JanDeDobbeleer.OhMyPosh"
    "Microsoft.PowerShell"
    "MartiCliment.UniGetUI"
    "Git.Git"
    "Bitwarden.CLI"
    "Bitwarden.Bitwarden"
    "Microsoft.VisualStudioCode"
    "JesseDuffield.lazygit"
    "CoreyButler.NVMforWindows"
    "ajeetdsouza.zoxide"
)

#--- GitHub CLI (optional) ---
if ($install.GitHubCli) { $wingetPackages += "GitHub.cli" }
else { Write-Host "GitHub CLI installation skipped." }

# Failed installs don't stop the run; they are listed at the end
$failures = [System.Collections.Generic.List[string]]::new()

# Exit codes that mean there was nothing to do rather than a failure
$wingetNothingToDo = @(
    -1978335189  # APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE: installed, no newer version available
    -1978335135  # APPINSTALLER_CLI_ERROR_PACKAGE_ALREADY_INSTALLED
)

foreach ($packageId in $wingetPackages) {
    Write-Host "Installing/Upgrading '$packageId' using winget..."
    # --source winget: without it the msstore source is searched too, and on a new machine winget stops
    # to ask for that source's agreement. --exact: match the ID exactly, not as a substring.
    winget install --id $packageId --exact --source winget --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -notin $wingetNothingToDo) {
        $failures.Add("winget: $packageId (exit code $LASTEXITCODE)")
    }
}

#--- Node.js via nvm (optional) ---
# Refresh PATH so nvm is available without restarting the session
Sync-SessionPath

if ($install.Node) {
    if (Get-Command nvm -ErrorAction SilentlyContinue) {
        Write-Host "Installing Node.js LTS via nvm..."
        nvm install lts
        nvm use lts
        if ($LASTEXITCODE -ne 0) { $failures.Add("Node.js LTS via nvm (exit code $LASTEXITCODE)") }

        # nvm switches the active version by repointing the symlink — refresh PATH again
        Sync-SessionPath
    }
    else {
        Write-Warning "nvm not found on PATH — relaunch this script in a new session to install Node.js."
        $failures.Add("Node.js LTS: nvm not found on PATH")
    }
}
else {
    Write-Host "Node.js installation skipped."
}

#--- Claude Code CLI (optional) ---
# Native build rather than `npm install -g @anthropic-ai/claude-code`: it self-updates in place and
# does not disappear when nvm switches the active Node version. Installs to %USERPROFILE%\.local\bin,
# which the installer does NOT put on PATH itself — without that, the VS Code extension cannot launch it.
if ($install.Claude) {
    Write-Host "Installing Claude Code CLI (native build)..."
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression

    # HKCU:\Environment\Path is REG_EXPAND_SZ and holds %USERPROFILE%, %NVM_HOME% and %NVM_SYMLINK%
    # tokens, so it has to be written through the registry with the value kind preserved.
    # [Environment]::SetEnvironmentVariable would expand those tokens and bake them out permanently.
    $claudeBinPath = '%USERPROFILE%\.local\bin'
    $rawUserPath = (Get-Item 'HKCU:\Environment').GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    $userPathEntries = $rawUserPath -split ';' | Where-Object { $_ }

    if ($userPathEntries -contains $claudeBinPath -or $userPathEntries -contains "$env:USERPROFILE\.local\bin") {
        Write-Host "'$claudeBinPath' is already on the User PATH." -ForegroundColor Green
    }
    else {
        $updatedUserPath = ($userPathEntries + $claudeBinPath) -join ';'
        Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value $updatedUserPath -Type ExpandString
        Write-Host "Added '$claudeBinPath' to the User PATH." -ForegroundColor Green
        Write-Warning "VS Code reads PATH at startup — restart it before using the Claude Code extension."
    }

    # Refresh PATH so claude is available without restarting the session
    Sync-SessionPath
}
else {
    Write-Host "Claude Code CLI installation skipped."
}

#--- Nerd Font ---
# oh-my-posh (installed above) ships a font installer; in an elevated session it installs for all users.
# Windows Terminal and VS Code use this font by its family name, "JetBrainsMono Nerd Font".
Write-Host "Installing JetBrainsMono Nerd Font using oh-my-posh..."
Sync-SessionPath
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh font install JetBrainsMono
    if ($LASTEXITCODE -ne 0) { $failures.Add("JetBrainsMono Nerd Font (exit code $LASTEXITCODE)") }
}
else {
    Write-Warning "oh-my-posh not found on PATH. Skipping the Nerd Font install."
    $failures.Add("JetBrainsMono Nerd Font: oh-my-posh not found on PATH")
}

#--- PowerShell Module Installation ---
Write-Host "Setting up PowerShell modules..."

# Trust PSGallery
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue


# PowerShell Modules
$psModules = @(
    "PSFzf"              # PSFzf to use fzf in PowerShell
    "CompletionPredictor" # PSReadLine predictions
    "posh-git"           # prompt posh-git
    "Terminal-Icons"     # terminal icons
)

foreach ($moduleName in $psModules) {
    if (Get-InstalledModule -Name $moduleName -ErrorAction SilentlyContinue) {
        Write-Host "Module '$moduleName' is already installed. Checking for updates..." -ForegroundColor Green
        Update-Module -Name $moduleName -Force
    }
    else {
        Write-Host "Module '$moduleName' not found. Installing..." -ForegroundColor Yellow
        Install-Module -Name $moduleName -Scope CurrentUser -Force -AllowClobber
    }
}

#--- Az PowerShell modules (optional) ---
if ($install.Az) {
    if (Get-InstalledModule -Name "Az" -ErrorAction SilentlyContinue) {
        Write-Host "Module 'Az' is already installed. Checking for updates..." -ForegroundColor Green
        Update-Module -Name "Az" -Force
    }
    else {
        Write-Host "Module 'Az' not found. Installing..." -ForegroundColor Yellow
        Install-Module -Name "Az" -Scope CurrentUser -Force -AllowClobber
    }
}
else {
    Write-Host "Az PowerShell modules installation skipped."
}

#--- PowerShell startup settings ---
# Skip pwsh's update check and telemetry on every shell start
Write-Host "Disabling PowerShell update check and telemetry..."
[Environment]::SetEnvironmentVariable('POWERSHELL_UPDATECHECK', 'Off', 'User')
[Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'User')

#--- Symbolic Links Setup ---
Write-Host "Setting up symbolic links for configuration files..."
# Define configuration paths and target files
$configItems = @(
    @{
        ProfileFullPath = $PROFILE
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\user_profile.ps1"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:APPDATA -ChildPath "Code\User\settings.json"
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\VisualStudioCode\settings.json"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\WindowsTerminal\settings.json"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "UniGetUI\Configuration"
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\UniGetUI"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "lazygit\config.yml"
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\lazygit\config.yml"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath ".gitconfig"
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\Git\gitconfig"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath ".claude\settings.json"
        TargetPath      = Join-Path -Path $repoRoot -ChildPath "Config\Claude\settings.json"
    },
    @{
        ProfileFullPath = 'C:\Tools\pwsh.exe'
        TargetPath      = Join-Path -Path $PSHOME -ChildPath "pwsh.exe"
    }
)

foreach ($item in $configItems) {
    $ProfileFullPath = $item.ProfileFullPath
    $TargetPath = $item.TargetPath
    $ProfilePath = Split-Path -Path $ProfileFullPath # Get the directory path

    if (-not (Test-Path -LiteralPath $TargetPath)) {
        Write-Warning "Link target '$TargetPath' does not exist. Skipping '$ProfileFullPath'."
        continue
    }

    # -Force so hidden items and broken symlinks (whose target is gone) are found too; Test-Path misses the latter
    $existingItem = Get-Item -LiteralPath $ProfileFullPath -Force -ErrorAction SilentlyContinue

    if ($existingItem.LinkType -eq 'SymbolicLink' -and
        [IO.Path]::GetFullPath($existingItem.Target).TrimEnd('\') -eq [IO.Path]::GetFullPath($TargetPath).TrimEnd('\')) {
        Write-Host "'$ProfileFullPath' already links to '$TargetPath'." -ForegroundColor Green
        continue
    }

    if ($existingItem.LinkType) {
        # A link pointing elsewhere holds no data of its own. Delete() removes only the link, never the folder it points to.
        Write-Host "Replacing link '$ProfileFullPath' (was pointing to '$($existingItem.Target)')..."
        $existingItem.Delete()
    }
    elseif ($existingItem) {
        # A real file or folder may hold settings not yet in the repo — keep it for a manual merge
        $backupPath = "$ProfileFullPath.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
        Write-Warning "'$ProfileFullPath' already exists. Moving it to '$backupPath'."
        Move-Item -LiteralPath $ProfileFullPath -Destination $backupPath -ErrorAction Stop
    }

    # Create profile directory if it doesn't exist
    if (!(Test-Path -Path $ProfilePath)) {
        New-Item -ItemType Directory -Path $ProfilePath -Force | Out-Null
    }

    Write-Host "Creating symbolic link for '$ProfileFullPath' pointing to '$TargetPath'..."
    New-Item -ItemType SymbolicLink -Path $ProfileFullPath -Target $TargetPath | Out-Null
}

# UniGetUI's package backup folder is a path on this machine, so the file is gitignored and written here
# (through the Config\UniGetUI link) instead of being shared between machines
$uniGetUIBackupSetting = Join-Path -Path $repoRoot -ChildPath "Config\UniGetUI\ChangeBackupOutputDirectory"
[IO.File]::WriteAllText($uniGetUIBackupSetting, $repoRoot)
Write-Host "UniGetUI package backups go to '$repoRoot'." -ForegroundColor Green

#--- Git hooks ---
# The pre-commit hook keeps the PowerToys backup and the VS Code extension list up to date
Sync-SessionPath
git -C $repoRoot config --local core.hooksPath .githooks
if ($LASTEXITCODE -eq 0) { Write-Host "Git hooks enabled (core.hooksPath = .githooks)." -ForegroundColor Green }
else { $failures.Add("git hooks: git config core.hooksPath failed (exit code $LASTEXITCODE)") }

#--- VS Code extensions ---
# Reinstalls the list the pre-commit hook saves (SaveVsCodeExtensions.ps1). code.cmd is resolved the same
# way as there: VS Code was only just installed by winget, so it may not be on this session's PATH yet.
$codePath = (Get-Command code.cmd -ErrorAction SilentlyContinue).Source
if (-not $codePath) {
    $codePath = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",  # per-user install (default)
        "C:\Program Files\Microsoft VS Code\bin\code.cmd"             # system-wide install
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
# Work machines (DEV-WNW-* hostnames) have their own list; until the first commit from one creates it,
# the private list is used instead
$extensionsFile = Join-Path -Path $repoRoot -ChildPath "Config\VisualStudioCode\extensions"
if ($env:COMPUTERNAME -like 'DEV-WNW-*') {
    $workExtensionsFile = Join-Path -Path $repoRoot -ChildPath "Config\VisualStudioCode\extensions.work"
    if (Test-Path $workExtensionsFile) { $extensionsFile = $workExtensionsFile }
    else { Write-Warning "'$workExtensionsFile' not found yet. Installing the extensions of the private list instead." }
}

if (-not $codePath) {
    Write-Warning "VS Code CLI (code.cmd) not found. Skipping extension install."
}
elseif (-not (Test-Path $extensionsFile)) {
    Write-Warning "'$extensionsFile' not found. Skipping extension install."
}
else {
    # Extension IDs are case-insensitive, and -notin compares case-insensitively
    $installedExtensions = & $codePath --list-extensions
    $missingExtensions = Get-Content $extensionsFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and $_ -notin $installedExtensions }

    if ($missingExtensions) {
        Write-Host "Installing $(@($missingExtensions).Count) missing VS Code extension(s)..."
        # One code.cmd call for all of them: every launch of the CLI takes a few seconds
        $installArguments = $missingExtensions | ForEach-Object { '--install-extension', $_ }
        & $codePath @installArguments
        if ($LASTEXITCODE -ne 0) { $failures.Add("VS Code extensions (exit code $LASTEXITCODE)") }
    }
    else {
        Write-Host "All VS Code extensions from '$extensionsFile' are already installed." -ForegroundColor Green
    }
}

#--- Remove older modules ---
# Only modules installed from the gallery (Install-Module) are cleaned up. Get-Module -ListAvailable
# would also return the modules that ship with Windows (Pester 3.4, PackageManagement 1.0.0.1,
# PSReadLine, ...) under Program Files\WindowsPowerShell and System32, which Windows PowerShell 5.1
# still loads — deleting those breaks it. Those modules have no PSGetModuleInfo.xml, so
# Get-InstalledModule never returns them.
Write-Host "Removing older versions of gallery-installed modules..."

# Versions are strings and may be prereleases ("2.4.0-beta0"), which [version] cannot parse. Get-InstalledModule
# without -AllVersions already returns the newest one, so every other installed version is older.
foreach ($installedModule in Get-InstalledModule) {
    $moduleName = $installedModule.Name
    $olderVersions = Get-InstalledModule -Name $moduleName -AllVersions |
        Where-Object { $_.Version -ne $installedModule.Version }

    foreach ($olderVersion in $olderVersions) {
        # A loaded module's version has no prerelease label, so compare against the numeric part only
        $numericVersion = [version]($olderVersion.Version -replace '-.*$')
        if (Get-Module -Name $moduleName | Where-Object { $_.Version -eq $numericVersion }) {
            Write-Warning "Module '$moduleName' version '$($olderVersion.Version)' is loaded in this session. Skipping."
            continue
        }

        Write-Host "Uninstalling '$moduleName' $($olderVersion.Version) (latest is $($installedModule.Version))..." -ForegroundColor DarkYellow

        # Remove the folder directly: Uninstall-Module refuses when another module (e.g. Az) depends on
        # this one, even though the dependency is satisfied by the newer version we keep.
        try {
            Remove-Item -Path $olderVersion.InstalledLocation -Recurse -Force -ErrorAction Stop
            Write-Host "'$moduleName' $($olderVersion.Version) uninstalled." -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to uninstall '$moduleName' $($olderVersion.Version): $($_.Exception.Message)"
        }
    }
}

#--- Final Steps ---
if ($failures.Count) {
    Write-Warning "Setup finished with $($failures.Count) failure(s):"
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}
else {
    Write-Host "Setup complete." -ForegroundColor Green
}
Write-Host "Open a new terminal to load the profile and the updated PATH."
Read-Host -Prompt "Press Enter to exit..."
