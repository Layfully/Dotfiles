<#
.SYNOPSIS
Installs the packages and tools a machine should have. chezmoi runs this when a package list or an optional
component changes, or this script does (home/.chezmoiscripts/run_onchange_after_20-packages.ps1.tmpl).

.DESCRIPTION
Everything here only installs what is missing; UniGetUI keeps things updated. That also means PowerShell 7 is
never upgraded by the pwsh running this script. Installers that need Administrator rights ask for them
themselves (UAC), unless this runs elevated already, as it does from Scripts\Bootstrap.ps1.
#>
# The Claude Code installer is only published as a script to download and run
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '')]
param(
    [ValidateSet('private', 'work')]
    [string] $Role = 'private',
    [switch] $GitHubCli,  # GitHub CLI
    [switch] $Node,       # latest Node.js LTS via nvm
    [switch] $ClaudeCode, # Claude Code CLI (native build)
    [switch] $Rider       # JetBrains Rider
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

# Runs a PowerShell command as this user without Administrator rights, even from an elevated session: a scheduled
# task with the Limited run level gets the user's normal token. Waits for it and returns its exit code; its
# output goes to $LogFile. A task that hasn't finished after $TimeoutMinutes is stopped.
function Invoke-Unelevated([string] $Command, [string] $LogFile, [int] $TimeoutMinutes = 15) {
    $taskName = "Dotfiles-Unelevated-$([guid]::NewGuid().ToString('N'))"
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes("& { $Command } *> '$LogFile'; exit `$LASTEXITCODE"))
    $action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-NoProfile -NonInteractive -EncodedCommand $encodedCommand"
    $principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited
    $null = Register-ScheduledTask -TaskName $taskName -Action $action -Principal $principal
    try {
        Start-ScheduledTask -TaskName $taskName
        $deadline = [datetime]::Now.AddMinutes($TimeoutMinutes)
        # 267011 (0x41303): not started yet; 267009 (0x41301): still running
        do {
            Start-Sleep -Seconds 2
            $lastResult = (Get-ScheduledTaskInfo -TaskName $taskName).LastTaskResult
        } while (($lastResult -in 267011, 267009) -and [datetime]::Now -lt $deadline)
        if ($lastResult -in 267011, 267009) {
            Stop-ScheduledTask -TaskName $taskName
            Write-Warning "Gave up waiting after $TimeoutMinutes minutes and stopped the task."
        }
        $lastResult
    }
    finally {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }
}

$isAdministrator = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')

#--- Packages and Developer Mode (WinGet Configuration) ---
# The base list every machine gets, then the work overlay's additions on work machines
$configurationFiles = @(Join-Path -Path $repoRoot -ChildPath "Config\WinGet\configuration.dsc.yaml")
$workConfigurationFile = Join-Path -Path $repoRoot -ChildPath "Config\WinGet\configuration.work.dsc.yaml"
if ($Role -eq 'work' -and (Test-Path -LiteralPath $workConfigurationFile)) { $configurationFiles += $workConfigurationFile }

foreach ($configurationFile in $configurationFiles) {
    Write-Host "Applying '$configurationFile' with winget configure..."
    winget configure --file $configurationFile --accept-configuration-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) { $failures.Add("winget configure: $configurationFile (exit code $LASTEXITCODE)") }
}
Sync-SessionPath

#--- Optional winget packages ---
$optionalPackages = [ordered]@{ 'GitHub.cli' = $GitHubCli; 'JetBrains.Rider' = $Rider }
foreach ($packageId in $optionalPackages.Keys) {
    if (-not $optionalPackages[$packageId]) { continue }
    Write-Host "Installing $packageId using winget..."
    # --source winget: without it the msstore source is searched too, and on a new machine winget stops
    # to ask for that source's agreement. --exact: match the ID exactly, not as a substring. --no-upgrade: an installed
    # package stays as it is (without it, install upgrades it, past any hold set in UniGetUI).
    winget install --id $packageId --exact --no-upgrade --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
    # Exit codes that mean there was nothing to do: APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE (installed,
    # no newer version available) and APPINSTALLER_CLI_ERROR_PACKAGE_ALREADY_INSTALLED
    if ($LASTEXITCODE -notin 0, -1978335189, -1978335135) { $failures.Add("winget: $packageId (exit code $LASTEXITCODE)") }
}

#--- Node.js via nvm (optional) ---
if ($Node) {
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

#--- Claude Code CLI (optional) ---
# Native build rather than `npm install -g @anthropic-ai/claude-code`: it self-updates in place and
# does not disappear when nvm switches the active Node version. Installs to %USERPROFILE%\.local\bin,
# which the installer does NOT put on PATH itself - without that, the VS Code extension cannot launch it.
if ($ClaudeCode) {
    $claudeExe = "$env:USERPROFILE\.local\bin\claude.exe"
    if (-not (Test-Path -LiteralPath $claudeExe)) {
        Write-Host "Installing Claude Code CLI (native build)..."
        $installCommand = 'Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression'
        if ($isAdministrator) {
            # A downloaded per-user installer: run it with the user's normal rights, not the elevated ones this
            # script has when Bootstrap.ps1 runs it
            $installLog = Join-Path -Path $env:TEMP -ChildPath 'claude-code-install.log'
            $installResult = Invoke-Unelevated -Command $installCommand -LogFile $installLog
            $installDetails = " (exit code $installResult, see $installLog)"
        }
        else {
            # In its own process: the installer sets StrictMode and $ErrorActionPreference, and calls exit on failure,
            # which would otherwise apply to (and end) this script
            pwsh -NoProfile -NonInteractive -Command $installCommand
            $installDetails = " (exit code $LASTEXITCODE)"
        }
        # Checked by the result rather than the exit code: a failed download still exits 0
        if (-not (Test-Path -LiteralPath $claudeExe)) { $failures.Add("Claude Code CLI: not installed$installDetails") }
    }

    # HKCU:\Environment\Path is REG_EXPAND_SZ and holds %USERPROFILE%, %NVM_HOME% and %NVM_SYMLINK%
    # tokens, so it has to be written through the registry with the value kind preserved.
    # [Environment]::SetEnvironmentVariable would expand those tokens and bake them out permanently.
    $claudeBinPath = '%USERPROFILE%\.local\bin'
    $rawUserPath = (Get-Item 'HKCU:\Environment').GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    $userPathEntries = $rawUserPath -split ';' | Where-Object { $_ }

    if ($userPathEntries -notcontains $claudeBinPath -and $userPathEntries -notcontains "$env:USERPROFILE\.local\bin") {
        $updatedUserPath = ($userPathEntries + $claudeBinPath) -join ';'
        Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value $updatedUserPath -Type ExpandString
        Write-Host "Added '$claudeBinPath' to the User PATH." -ForegroundColor Green
        Write-Warning "VS Code reads PATH at startup - restart it before using the Claude Code extension."
    }
    Sync-SessionPath
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
