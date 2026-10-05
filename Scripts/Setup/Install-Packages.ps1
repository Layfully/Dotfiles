<#
.SYNOPSIS
Installs the packages and tools a machine should have. chezmoi runs this when one of its package lists changes,
or this script does (home/.chezmoiscripts/run_onchange_after_20-packages.ps1.tmpl).

.DESCRIPTION
Everything here only installs what is missing; UniGetUI keeps things updated. That also means PowerShell 7 is
never upgraded by the pwsh running this script. Installers that need Administrator rights ask for them
themselves (UAC), unless this runs elevated already, as it does from Scripts\Bootstrap.ps1.
#>
param(
    [ValidateSet('private', 'work')]
    [string] $Role = 'private'
)

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\Setup -> repo root

# Failed steps don't stop the run; they are listed at the end
$failures = [System.Collections.Generic.List[string]]::new()

# Reloads PATH from the registry, so tools installed during this run can be found without a new session.
# GetEnvironmentVariable expands PATH's %TOKENS% with this process's variables, so variables an installer added
# during this run (nvm's NVM_HOME and NVM_SYMLINK) are loaded first; without them nvm's entries stay unexpanded.
function Sync-SessionPath {
    # User first: like Windows, a user variable wins over a machine one of the same name
    foreach ($scope in 'User', 'Machine') {
        $variables = [System.Environment]::GetEnvironmentVariables($scope)
        foreach ($name in $variables.Keys) {
            if ($name -ne 'Path' -and $null -eq [System.Environment]::GetEnvironmentVariable($name)) {
                [System.Environment]::SetEnvironmentVariable($name, $variables[$name])
            }
        }
    }
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

#--- Packages and Developer Mode (WinGet Configuration) ---
# The base list every machine gets, then the role's own list
$configurationFiles = @(Join-Path -Path $repoRoot -ChildPath "Config\WinGet\configuration.dsc.yaml")
$roleConfigurationFile = Join-Path -Path $repoRoot -ChildPath "Config\WinGet\configuration.$Role.dsc.yaml"
if (Test-Path -LiteralPath $roleConfigurationFile) { $configurationFiles += $roleConfigurationFile }

foreach ($configurationFile in $configurationFiles) {
    Write-Host "Applying '$configurationFile' with winget configure..."
    winget configure --file $configurationFile --accept-configuration-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) { $failures.Add("winget configure: $configurationFile (exit code $LASTEXITCODE)") }
}
Sync-SessionPath

#--- Node.js LTS through nvm, where a package list has nvm ---
# By the lists rather than by an nvm on PATH, which may be left over from a list that no longer has it
if (Select-String -LiteralPath $configurationFiles -Pattern 'CoreyButler.NVMforWindows' -SimpleMatch -Quiet) {
    if (Get-Command nvm -ErrorAction SilentlyContinue) {
        Write-Host "Installing Node.js LTS via nvm..."
        nvm install lts
        $nvmExitCode = $LASTEXITCODE
        if ($nvmExitCode -eq 0) {
            nvm use lts
            $nvmExitCode = $LASTEXITCODE
        }
        # nvm switches the active version by repointing the symlink - refresh PATH again
        Sync-SessionPath
        if ($nvmExitCode -ne 0) { $failures.Add("Node.js LTS via nvm (exit code $nvmExitCode)") }
        elseif (-not (Get-Command node -ErrorAction SilentlyContinue)) { $failures.Add("Node.js LTS: node not found on PATH after nvm use") }
    }
    else {
        $failures.Add("Node.js LTS: nvm not found on PATH (open a new terminal and run chezmoi apply)")
    }
}

#--- Nerd Font ---
# oh-my-posh ships a font installer: elevated it installs for all users, otherwise for this user. Windows
# Terminal and VS Code use this font by its family name, "JetBrainsMono Nerd Font".
$fontKeys = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
$fontInstalled = $fontKeys | ForEach-Object { Get-Item -Path $_ -ErrorAction SilentlyContinue } |
    Where-Object { $_.GetValueNames() -like 'JetBrainsMono N*' }
if (-not $fontInstalled) {
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        Write-Host "Installing JetBrainsMono Nerd Font using oh-my-posh..."
        oh-my-posh font install JetBrainsMono
        if ($LASTEXITCODE -ne 0) { $failures.Add("JetBrainsMono Nerd Font (exit code $LASTEXITCODE)") }
    }
    else {
        $failures.Add("JetBrainsMono Nerd Font: oh-my-posh not found on PATH")
    }
}

#--- Result ---
# Non-zero makes chezmoi report it and run this script again on the next apply
if ($failures.Count) {
    Write-Warning "Package setup finished with $($failures.Count) failure(s):"
    $failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}
Write-Host "Packages are set up. Open a new terminal to pick up the updated PATH." -ForegroundColor Green
exit 0
