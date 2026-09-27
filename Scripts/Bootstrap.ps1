<#
.SYNOPSIS
Sets up a new machine from this clone. Run it once, as Administrator, in PowerShell 7.

.DESCRIPTION
Installs chezmoi, runs `chezmoi init` (which records the machine's role and asks about the optional components),
puts the age key in place on a work machine, and runs `chezmoi apply`: that links the configs and runs the setup
scripts in home/.chezmoiscripts (packages and Developer Mode, PowerShell modules, VS Code extensions, PowerToys).
Elevated, those run without UAC prompts. After this, `chezmoi update` keeps the machine in sync.

Optional components are asked once. Pass a switch to answer ahead: -Node to install, -Node:$false to skip.

.EXAMPLE
pwsh -NoProfile -File Scripts/Bootstrap.ps1 -GitHubCli -Node:$false -ClaudeCode -Az:$false
#>
#Requires -Version 7
param(
    [switch]$GitHubCli,  # GitHub CLI
    [switch]$Node,       # latest Node.js LTS via nvm
    [switch]$ClaudeCode, # Claude Code CLI (native build)
    [switch]$Az,         # Az PowerShell modules
    # Set when the script relaunches itself elevated: that new window then stays open at the end
    [switch]$Relaunched
)

$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
if (-not $isAdministrator) {
    Write-Warning "Administrator rights are required. Relaunching elevated..."
    # Forward the switches as -Name:True / -Name:False, which pwsh -File binds back to the switch.
    # Start-Process joins -ArgumentList with spaces and does not quote, so the script path is quoted by hand.
    $forwardedArguments = $PSBoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key):$([bool]$_.Value)" }
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
}
$answers = foreach ($componentName in $promptTexts.Keys) {
    if ($PSBoundParameters.ContainsKey($componentName)) {
        "$($promptTexts[$componentName])=$(([bool]$PSBoundParameters[$componentName]).ToString().ToLower())"
    }
}
$initArguments = @('init', '--source', $repoRoot)
if ($answers) { $initArguments += '--promptBool', ($answers -join ',') }
chezmoi @initArguments
if ($LASTEXITCODE -ne 0) {
    Write-Error "chezmoi init failed (exit code $LASTEXITCODE)."
    Exit-Bootstrap 1
}

#--- age key (work machines) ---
# The work overlay is encrypted with it. A private machine never decrypts anything, so it doesn't need the key.
$role = (chezmoi data --format json | ConvertFrom-Json).role
$keyFile = Join-Path -Path $HOME -ChildPath ".config\chezmoi\key.txt"
if ($role -eq 'work' -and -not (Test-Path -LiteralPath $keyFile)) {
    Write-Host "This machine has the work role. The work overlay is encrypted with the age key kept in Bitwarden." -ForegroundColor Cyan
    $secretKey = (Read-Host -Prompt "Paste the key's AGE-SECRET-KEY-... line").Trim()
    if ($secretKey -notmatch '^AGE-SECRET-KEY-1[0-9A-Z]+$') {
        Write-Error "That is not an age secret key. Put the key file at '$keyFile' and run this script again."
        Exit-Bootstrap 1
    }
    $null = New-Item -ItemType Directory -Path (Split-Path -Path $keyFile) -Force
    [IO.File]::WriteAllText($keyFile, "$secretKey`n")
}

#--- chezmoi apply ---
Write-Host "Running chezmoi apply (role: $role)..."
chezmoi apply
if ($LASTEXITCODE -ne 0) { Write-Warning "chezmoi apply reported failures (above). Fix them and run 'chezmoi apply' again." }
else { Write-Host "Setup complete. From now on, 'chezmoi update' pulls the repo and applies it." -ForegroundColor Green }
Write-Host "Open a new terminal to load the profile and the updated PATH."
Exit-Bootstrap $LASTEXITCODE
