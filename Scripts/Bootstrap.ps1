<#
.SYNOPSIS
Sets up a new machine from this clone. Run it once, as Administrator, in PowerShell 7.

.DESCRIPTION
Installs chezmoi, runs `chezmoi init` (which asks for the machine's role and its Dev Drive), puts the age key in
place on a work machine, and runs `chezmoi apply`: that links the configs and runs the setup scripts in
home/.chezmoiscripts (packages and Developer Mode, PowerShell modules, VS Code extensions, PowerToys).
Elevated, those run without UAC prompts. After this, `chezmoi update` keeps the machine in sync.

Both questions are asked once. Pass them to answer ahead: -Role work or -Role private; -DevDrive D: puts the
package caches on that Dev Drive, -DevDrive none leaves them where they are.

.EXAMPLE
pwsh -NoProfile -File Scripts/Bootstrap.ps1 -Role work -DevDrive D:
#>
#Requires -Version 7
param(
    # private: the base setup; work: adds the encrypted work overlay (needs the age key's passphrase)
    [ValidateSet('private', 'work')]
    [string]$Role,
    # The Dev Drive for the package caches, like D:, or none
    [string]$DevDrive,
    # Set when the script relaunches itself elevated: that new window then stays open at the end
    [switch]$Relaunched
)

$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
if (-not $isAdministrator) {
    Write-Warning "Administrator rights are required. Relaunching elevated..."
    # Start-Process joins -ArgumentList with spaces and does not quote, so the script path is quoted by hand
    $forwardedArguments = $PSBoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key)", $_.Value }
    Start-Process -Verb RunAs pwsh -ArgumentList (@("-NoProfile", "-File", "`"$PSCommandPath`"", "-Relaunched") + $forwardedArguments)
    exit
}

# Ends the script. A window the script opened for itself stays open until Enter, so its output can be read.
function Exit-Bootstrap([int] $ExitCode) {
    if ($Relaunched) { Read-Host -Prompt "Press Enter to exit..." }
    exit $ExitCode
}

$repoRoot = Split-Path -Path $PSScriptRoot -Parent

#--- chezmoi ---
if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    Write-Host "Installing chezmoi using winget..."
    winget install --id twpayne.chezmoi --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        Write-Error "chezmoi was not found after installing it. Open a new terminal and run this script again."
        Exit-Bootstrap 1
    }
}

#--- chezmoi init ---
# Writes ~/.config/chezmoi/chezmoi.toml from home/.chezmoi.toml.tmpl. The prompt texts must match the ones there.
$initArguments = @('init', '--source', $repoRoot)
if ($Role) { $initArguments += '--promptChoice', "Machine role (work adds the encrypted work overlay)=$Role" }
if ($DevDrive) { $initArguments += '--promptString', "Dev Drive for the package caches (a drive like D: or none)=$DevDrive" }
chezmoi @initArguments
if ($LASTEXITCODE -ne 0) {
    Write-Error "chezmoi init failed (exit code $LASTEXITCODE)."
    Exit-Bootstrap 1
}

#--- age key (work machines) ---
# The work overlay is encrypted with it. A private machine never decrypts anything, so it doesn't need the key.
# The repo holds the key itself encrypted with a passphrase (kept in Bitwarden); chezmoi asks for it here.
$role = (chezmoi data --format json | ConvertFrom-Json).role
$keyFile = Join-Path -Path $HOME -ChildPath ".config\chezmoi\key.txt"
if ($role -eq 'work' -and -not (Test-Path -LiteralPath $keyFile)) {
    Write-Host "This machine has the work role. Enter the age key's passphrase (in Bitwarden) to decrypt the work overlay." -ForegroundColor Cyan
    $null = New-Item -ItemType Directory -Path (Split-Path -Path $keyFile) -Force
    chezmoi age decrypt --passphrase --output $keyFile (Join-Path -Path $repoRoot -ChildPath 'Config\age\key.txt.age')
    if ($LASTEXITCODE -ne 0) {
        Remove-Item -LiteralPath $keyFile -ErrorAction SilentlyContinue
        Write-Error "Decrypting the age key failed. Run this script again, or put the key file at '$keyFile'."
        Exit-Bootstrap 1
    }
}

#--- chezmoi apply ---
Write-Host "Running chezmoi apply (role: $role)..."
chezmoi apply
if ($LASTEXITCODE -ne 0) { Write-Warning "chezmoi apply reported failures (above). Fix them and run 'chezmoi apply' again." }
else { Write-Host "Setup complete. From now on, 'chezmoi update' pulls the repo and applies it." -ForegroundColor Green }
Write-Host "Open a new terminal to load the profile and the updated PATH."
Exit-Bootstrap $LASTEXITCODE
