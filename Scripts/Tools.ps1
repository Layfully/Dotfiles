$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
$commandLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $PID").CommandLine
$isNoProfile = $commandLine -like '*-NoProfile*'

if (-not $isAdministrator -or -not $isNoProfile) {
    $relaunchReason = if (-not $isAdministrator) { "Administrator privileges are required." } else { "A clean, no-profile session is required." }
    Write-Warning "$relaunchReason Attempting to relaunch correctly..."

    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $scriptPath = $MyInvocation.MyCommand.Path + $MyInvocation.UnboundArguments
        Start-Process -Verb RunAs wt -ArgumentList "pwsh.exe", "-NoProfile", "-File", $scriptPath
        Exit # Exit the current, incorrect session.
    }
}

Write-Host "Script is running correctly (Administrator + No Profile)." -ForegroundColor Green

$otherPwshProcesses = Get-Process -Name pwsh -ErrorAction SilentlyContinue | Where-Object { $_.Id -ne $PID }

if ($otherPwshProcesses) {
    Write-Warning "For a safe installation, all other PowerShell sessions must be closed to prevent file locks."
    Write-Host "The following PowerShell processes were found:" -ForegroundColor Yellow
    $otherPwshProcesses | Format-Table Id, ProcessName, MainWindowTitle -AutoSize

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


#--- Winget Setup ---
# Add winget cdn source if not already present.
$sourcesList = winget source list | Out-String
$sourceName = "winget"
$sourceURL = "https://cdn.winget.microsoft.com/cache"

if ($sourcesList -like "*$sourceName*") {
    Write-Output "The winget source '$sourceName' is already added."
}
else {
    Write-Output "The winget source '$sourceName' is not added. Adding now..."
    winget source add --name $sourceName --url $sourceURL
}

#--- Tool Installation and Upgrade ---
Write-Host "Ensuring essential tools are installed and up-to-date..."

# Use a list for easier management and iteration
$wingetPackages = @(
    "Microsoft.PowerToys"
    "junegunn.fzf"
    "Microsoft.WindowsTerminal"
    "JanDeDobbeleer.OhMyPosh"
    "Microsoft.PowerShell",
    "MartiCliment.UniGetUI"
    "Git.Git"
    "Bitwarden.CLI"
    "Bitwarden.Bitwarden"
    "Microsoft.VisualStudioCode"
    "JesseDuffield.lazygit"
    "CoreyButler.NVMforWindows"
)

foreach ($packageId in $wingetPackages) {
    Write-Host "Installing/Upgrading '$packageId' using winget..."
    winget install --id $packageId --silent --accept-package-agreements
}

#--- GitHub CLI (optional) ---
$UserConfirmation = Read-Host -Prompt "Do you want to install GitHub CLI? (Y/N)"
if ($UserConfirmation -match "^y(es)?$") {
    Write-Host "Installing/Upgrading 'GitHub.cli' using winget..."
    winget install --id GitHub.cli --silent --accept-package-agreements

    # Refresh PATH so gh is available without restarting the session
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")

    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "Ensuring GitHub CLI extension 'gh-copilot' is installed and up-to-date..."
        (gh extension list | Select-String gh-copilot) ? (gh extension upgrade gh-copilot) : (gh extension install github/gh-copilot)
    }
    else {
        Write-Warning "gh not found after install — relaunch this script in a new session to install the gh-copilot extension."
    }
}
else {
    Write-Host "GitHub CLI installation skipped."
}


#--- Node.js via nvm (optional) ---
# Refresh PATH so nvm is available without restarting the session
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("PATH", "User")

$UserConfirmation = Read-Host -Prompt "Do you want to install the latest Node.js LTS via nvm? (Y/N)"
if ($UserConfirmation -match "^y(es)?$") {
    if (Get-Command nvm -ErrorAction SilentlyContinue) {
        Write-Host "Installing Node.js LTS via nvm..."
        nvm install lts
        nvm use lts

        # nvm switches the active version by repointing the symlink — refresh PATH again
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("PATH", "User")
    }
    else {
        Write-Warning "nvm not found on PATH — relaunch this script in a new session to install Node.js."
    }
}
else {
    Write-Host "Node.js installation skipped."
}

#--- Claude Code CLI (optional) ---
$UserConfirmation = Read-Host -Prompt "Do you want to install the Claude Code CLI? (Y/N)"
if ($UserConfirmation -match "^y(es)?$") {
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "Installing Claude Code CLI..."
        npm install -g @anthropic-ai/claude-code
    }
    else {
        Write-Warning "npm not found on PATH — install Node.js first, then relaunch this script."
    }
}
else {
    Write-Host "Claude Code CLI installation skipped."
}

#--- PowerShell Module Installation ---
Write-Host "Setting up PowerShell modules..."

# Trust PSGallery
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue

# Install chocolatey
if (-not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Host "Upgrading Chocolatey..."
    choco upgrade chocolatey -y --no-progress # Add -y and --no-progress for unattended install
}

# Chocolatey Packages
$chocoPackages = @(
    "nerd-fonts-jetbrainsmono"
    #"ripgrep"
)

foreach ($package in $chocoPackages) {
    Write-Host "Upgrading/Installing '$package' using Chocolatey..."
    choco upgrade $package -y --no-progress
}

# PowerShell Modules
$psModules = @(
    "ZLocation"          # z for faster folder navigation
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
$UserConfirmation = Read-Host -Prompt "Do you want to install the Az PowerShell modules? (Y/N)"
if ($UserConfirmation -match "^y(es)?$") {
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

#--- Symbolic Links Setup ---
Write-Host "Setting up symbolic links for configuration files..."
# Define configuration paths and target files
$configItems = @(
    @{
        ProfileFullPath = $PROFILE
        TargetPath      = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\user_profile.ps1"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:APPDATA -ChildPath "Code\User\settings.json"
        TargetPath      = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\VisualStudioCode\settings.json"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        TargetPath      = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\WindowsTerminal\settings.json"
    },
    @{
        ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "UniGetUI\Configuration"
        TargetPath      = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\UniGetUI"
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

    Write-Host "Creating symbolic link for '$ProfileFullPath' pointing to '$TargetPath'..."

    # Create profile directory if it doesn't exist
    if (!(Test-Path -Path $ProfilePath)) {
        New-Item -ItemType Directory -Path $ProfilePath -Force | Out-Null
    }

    # Remove existing profile file and create symbolic link in one line, suppressing errors if file doesn't exist to remove
    Remove-Item -Path $ProfileFullPath -Force -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path $ProfileFullPath -Target $TargetPath
}

#--- Remove older modules ---

$modules = Get-Module -ListAvailable | Group-Object -Property Name

foreach ($moduleGroup in $modules) {
    $moduleName = $moduleGroup.Name
    $moduleVersions = Get-Module -Name $moduleName -ListAvailable | Sort-Object Version -Descending

    if ($moduleVersions -eq $null -or $moduleVersions.Count -le 1) {
        continue  # Nothing to do if only one or zero versions
    }

    $latestVersion = $moduleVersions[0].Version
    Write-Host "Latest version of '$moduleName' is: $latestVersion"

    for ($i = 1; $i -lt $moduleVersions.Count; $i++) {
        $currentVersion = $moduleVersions[$i].Version
        $currentModule = $moduleVersions[$i]

        $isLoaded = $false
        if (Get-Module -Name $moduleName -ErrorAction SilentlyContinue) {
            # Check if *this specific version* is loaded.
            $loadedModules = Get-Module -Name $moduleName
            foreach ($loadedModule in $loadedModules) {
                if ($loadedModule.Version -eq $currentVersion) {
                    $isLoaded = $true
                    break;
                }
            }
        }

        if ($isLoaded) {
            Write-Host "Module '$moduleName' version '$currentVersion' is currently loaded." -ForegroundColor Yellow

            try {
                Write-Host "Attempting to remove module '$moduleName' version '$currentVersion' from session."
                Remove-Module -Name $moduleName -RequiredVersion $currentVersion -Force -ErrorAction Stop  # Remove from current session
            }
            catch {
                Write-Warning "Could not remove loaded module '$moduleName' version '$currentVersion' from session.  Skipping uninstallation. Error: $($_.Exception.Message)"
                continue

            }
        }

        Write-Host "Uninstalling older version: $currentVersion (from $($currentModule.ModuleBase))" -ForegroundColor DarkYellow

        try {
            Remove-Item -Path $currentModule.ModuleBase -Recurse -Force -ErrorAction Stop
            Write-Host "Version $currentVersion uninstalled successfully." -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to uninstall version $($currentVersion): $($_.Exception.Message)"
        }
    }
}

git config --global user.email "git@adriangaborek.dev"
git config --global user.name "Adrian Gaborek"

#--- Final Steps ---
Write-Host "Setup complete."

# Reload profile so that changes are applied
Write-Host "Reloading PowerShell profile..."
. $profile
Read-Host -Prompt "Press Enter to exit..."
