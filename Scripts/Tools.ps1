param (
    [switch]$SkipVisualStudio = $false
)

#--- Self-Elevation ---
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = $MyInvocation.MyCommand.Path + $MyInvocation.UnboundArguments
        Write-Output $CommandLine
        Start-Process -Verb RunAs wt -ArgumentList "pwsh.exe", "-File", $CommandLine
        Exit
    }
}

#--- Visual Studio ---
if (-not $SkipVisualStudio) {
    $UserConfirmation = Read-Host -Prompt "Do you want to install Visual Studio? (Y/N)"

    if ($UserConfirmation -cmatch "^y(es)?") {
        # Use -cmatch for case-insensitive and more flexible matching
        Write-Host "Continuing with Visual Studio installation..."
        $vsConfigPath = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\VisualStudio\installationConfig2022.vsconfig"
        winget install --id Microsoft.VisualStudio.2022.Professional --override "--wait --quiet --addProductLang En-us --config `"$vsConfigPath`"" # Quote config path in case it contains spaces
    }
    else {
        Write-Host "Visual Studio installation cancelled by the user."
    }
}
else {
    Write-Host "Skipping Visual Studio installation as requested."
}
#--- Visual Studio extensions ---
#this one could be nice test if this is good
#choco install -y gitdiffmargin

#resharper is alternative
#choco install -y resharper-ultimate-all --package-parameters="'/NoCpp'"


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
    "GitHub.cli"
    "JanDeDobbeleer.OhMyPosh"
    "Microsoft.PowerShell",
    "MartiCliment.UniGetUI"
    "Git.Git"
    "Bitwarden.Bitwarden"
    "Microsoft.VisualStudioCode"
)

foreach ($packageId in $wingetPackages) {
    Write-Host "Installing/Upgrading '$packageId' using winget..."
    winget install --id $packageId --silent --accept-package-agreements
}

# GitHub CLI Extension - gh-copilot
Write-Host "Ensuring GitHub CLI extension 'gh-copilot' is installed and up-to-date..."
(gh extension list | Select-String gh-copilot) ? (gh extension upgrade gh-copilot) : (gh extension install github/gh-copilot)

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
    #"Az"                 # Azure PowerShell modules
)

foreach ($moduleName in $psModules) {
    Write-Host "Installing PowerShell module '$moduleName'..."
    Install-Module -Name $moduleName -Scope CurrentUser -Force
}

#--- Symbolic Links Setup ---
Write-Host "Setting up symbolic links for configuration files..."
# Define configuration paths and target files
$configItems = @(
    @{
        ProfileFullPath = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
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
    #@{
    #    ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "microsoft\visualstudio\17.0_12268c9f\settings\CurrentSettings.vssettings"
    #    TargetPath      = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\VisualStudio\settings.vssettings"
    #}
    @{
        ProfileFullPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "UniGetUI\Configuration"
        TargetPath      = Join-Path -Path $env:USERPROFILE -ChildPath "Dotfiles\Config\UniGetUI"
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
}

git config --global user.email "git@adriangaborek.dev"
git config --global user.name "Adrian Gaborek"

#--- Final Steps ---
Write-Host "Setup complete."

# Reload profile so that changes are applied
Write-Host "Reloading PowerShell profile..."
. $profile
Read-Host -Prompt "Press Enter to exit..."
