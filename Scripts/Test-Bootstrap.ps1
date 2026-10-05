<#
.SYNOPSIS
Tries Scripts\Bootstrap.ps1 on a clean, disposable Windows in Windows Sandbox, as on a new machine.

.DESCRIPTION
The sandbox starts without winget, PowerShell 7 or Git, like a fresh install, so it sets those up first. Then it
clones this repo - its last commit, so commit what you want to test - and runs the bootstrap as a private machine
without a Dev Drive. The work role isn't tested: it needs the age key.

Output goes to a folder on this machine, shown when the script starts. With -Wait, this script waits for the
sandbox to finish and prints the result. Closing the sandbox window throws everything in it away.

Windows Sandbox is an optional Windows feature (Pro and up). To turn it on, as Administrator, then reboot:
    Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -All

.EXAMPLE
pwsh -NoProfile -File Scripts/Test-Bootstrap.ps1 -Wait
#>
param(
    [switch] $Wait,              # wait for the sandbox run to finish and print its result
    [int] $TimeoutMinutes = 60   # with -Wait: give up after this long
)

$sandboxExe = Join-Path -Path $env:SystemRoot -ChildPath 'System32\WindowsSandbox.exe'
if (-not (Test-Path -LiteralPath $sandboxExe)) {
    Write-Error ("Windows Sandbox isn't enabled. As Administrator, run 'Enable-WindowsOptionalFeature -Online " +
        "-FeatureName Containers-DisposableClientVM -All', reboot, and try again.")
    exit 1
}

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$runFolder = Join-Path -Path $env:TEMP -ChildPath "DotfilesSandbox-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$null = New-Item -ItemType Directory -Path $runFolder

# Runs inside the sandbox, in its Windows PowerShell 5.1: keep it 5.1-compatible
$inSandbox = @'
$ErrorActionPreference = 'Stop'
$log = 'C:\Run\sandbox.log'
function Step([string] $Text) { Add-Content -Path $log -Value "$(Get-Date -Format 'HH:mm:ss') $Text" }
function Sync-SessionPath { $env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('PATH', 'User') }
try {
    Step 'Installing winget (the sandbox has no Store)'
    Install-PackageProvider -Name NuGet -Force | Out-Null
    Install-Module -Name Microsoft.WinGet.Client -Repository PSGallery -Force
    Repair-WinGetPackageManager -AllUsers -Latest
    Sync-SessionPath

    Step 'Installing the prerequisites: PowerShell 7 and Git'
    foreach ($id in 'Microsoft.PowerShell', 'Git.Git') {
        winget install --id $id --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
        if ($LASTEXITCODE -ne 0) { throw "winget install $id failed (exit code $LASTEXITCODE)" }
    }
    Sync-SessionPath

    Step 'Cloning the repo (its last commit)'
    git -c safe.directory='*' clone --quiet C:\Source C:\Dotfiles
    if ($LASTEXITCODE -ne 0) { throw "git clone failed (exit code $LASTEXITCODE)" }

    Step 'Running Scripts\Bootstrap.ps1'
    # From here on, redirected stderr of the tools is output to keep; with Stop, 5.1 would throw on the first line
    $ErrorActionPreference = 'Continue'
    & pwsh -NoProfile -File C:\Dotfiles\Scripts\Bootstrap.ps1 -Role private -DevDrive none *>&1 |
        Out-File -FilePath 'C:\Run\bootstrap.log' -Encoding utf8
    $bootstrapExit = $LASTEXITCODE
    Sync-SessionPath

    Step "Bootstrap exit code: $bootstrapExit. Checking the result"
    $status = chezmoi status --exclude=scripts 2>&1 | Out-String
    chezmoi verify --exclude=scripts 2>&1 | Out-Null
    $verifyExit = $LASTEXITCODE
    $profileLoads = & pwsh -NoLogo -Command '[bool](Get-Command cheat -ErrorAction Ignore)'
    $result = "bootstrap exit: $bootstrapExit`nchezmoi verify: $(if ($verifyExit -eq 0) { 'matches' } else { 'DIFFERS' })`n" +
              "profile loads: $profileLoads`nchezmoi status:`n$status"
    Set-Content -Path 'C:\Run\result.txt' -Value $result
}
catch {
    Step "FAILED: $($_.Exception.Message)"
    Set-Content -Path 'C:\Run\result.txt' -Value "FAILED: $($_.Exception.Message)"
}
Step 'Done'
'@
[IO.File]::WriteAllText((Join-Path -Path $runFolder -ChildPath 'in-sandbox.ps1'), $inSandbox)

# The repo read-only (the run clones it), the run folder writable for the logs
$configuration = @"
<Configuration>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>$([Security.SecurityElement]::Escape($repoRoot))</HostFolder>
      <SandboxFolder>C:\Source</SandboxFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
    <MappedFolder>
      <HostFolder>$([Security.SecurityElement]::Escape($runFolder))</HostFolder>
      <SandboxFolder>C:\Run</SandboxFolder>
      <ReadOnly>false</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Run\in-sandbox.ps1</Command>
  </LogonCommand>
</Configuration>
"@
$configurationFile = Join-Path -Path $runFolder -ChildPath 'bootstrap-test.wsb'
[IO.File]::WriteAllText($configurationFile, $configuration)

Write-Host "Testing commit $(git -C $repoRoot rev-parse --short HEAD) in Windows Sandbox. Logs: $runFolder"
Start-Process -FilePath $sandboxExe -ArgumentList "`"$configurationFile`""

if ($Wait) {
    $resultFile = Join-Path -Path $runFolder -ChildPath 'result.txt'
    Write-Host "Waiting for the sandbox run (usually 15-30 minutes)..."
    $deadline = [datetime]::Now.AddMinutes($TimeoutMinutes)
    while (-not (Test-Path -LiteralPath $resultFile) -and [datetime]::Now -lt $deadline) { Start-Sleep -Seconds 30 }
    if (-not (Test-Path -LiteralPath $resultFile)) {
        Write-Error "No result after $TimeoutMinutes minutes (was the sandbox window closed?). Logs: $runFolder"
        exit 1
    }
    $result = Get-Content -LiteralPath $resultFile -Raw
    $result
    # Success only if the bootstrap exited 0 and chezmoi found the machine matching the repo
    if ($result -notmatch '(?m)^bootstrap exit: 0\s*$' -or $result -notmatch '(?m)^chezmoi verify: matches\s*$') { exit 1 }
}
