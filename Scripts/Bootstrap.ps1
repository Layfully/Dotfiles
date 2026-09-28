<#
.SYNOPSIS
Sets up a new machine from this clone. Run it once, as Administrator, in PowerShell 7.

.DESCRIPTION
Installs chezmoi, runs `chezmoi init` (which asks for the machine's role and about the optional components),
puts the age key in place on a work machine, and runs `chezmoi apply`: that links the configs and runs the setup
scripts in home/.chezmoiscripts (packages and Developer Mode, PowerShell modules, VS Code extensions, PowerToys).
Elevated, those run without UAC prompts. After this, `chezmoi update` keeps the machine in sync.

The role and the optional components are asked once. Pass them to answer ahead: -Role work or -Role private,
and a switch per component: -Node to install, -Node:$false to skip.

.EXAMPLE
pwsh -NoProfile -File Scripts/Bootstrap.ps1 -Role work -GitHubCli -Node:$false -ClaudeCode -Az:$false -Rider:$false
#>
#Requires -Version 7
param(
    # private: the base setup; work: adds the encrypted work overlay (needs the age key's passphrase)
    [ValidateSet('private', 'work')]
    [string]$Role,
    [switch]$GitHubCli,  # GitHub CLI
    [switch]$Node,       # latest Node.js LTS via nvm
    [switch]$ClaudeCode, # Claude Code CLI (native build)
    [switch]$Az,         # Az PowerShell modules
    [switch]$Rider,      # JetBrains Rider
    # Set when the script relaunches itself elevated: that new window then stays open at the end
    [switch]$Relaunched
)

$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
if (-not $isAdministrator) {
    Write-Warning "Administrator rights are required. Relaunching elevated..."
    # Forward the switches as -Name:True / -Name:False, which pwsh -File binds back to the switch, and -Role as is.
    # Start-Process joins -ArgumentList with spaces and does not quote, so the script path is quoted by hand.
    $forwardedArguments = $PSBoundParameters.GetEnumerator() | ForEach-Object {
        if ($_.Value -is [switch]) { "-$($_.Key):$([bool]$_.Value)" } else { "-$($_.Key)", $_.Value }
    }
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
$promptTexts = [ordered]@{
    GitHubCli  = "Install the GitHub CLI"
    Node       = "Install Node.js LTS through nvm"
    ClaudeCode = "Install the Claude Code CLI"
    Az         = "Install the Az PowerShell modules"
    Rider      = "Install JetBrains Rider"
}
$answers = foreach ($componentName in $promptTexts.Keys) {
    if ($PSBoundParameters.ContainsKey($componentName)) {
        "$($promptTexts[$componentName])=$(([bool]$PSBoundParameters[$componentName]).ToString().ToLower())"
    }
}
$initArguments = @('init', '--source', $repoRoot)
if ($answers) { $initArguments += '--promptBool', ($answers -join ',') }
if ($Role) { $initArguments += '--promptChoice', "Machine role (work adds the encrypted work overlay)=$Role" }
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
