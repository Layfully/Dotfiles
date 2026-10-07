<#
.SYNOPSIS
Merges Config\Docker\settings.json into Docker Desktop's settings. chezmoi runs this on work machines when that file or
this script changes.

.DESCRIPTION
Why the settings are merged rather than linked, and when this fails: the README's Docker Desktop Settings.
#>

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\Setup -> repo root
$settingsStore = Join-Path -Path $env:APPDATA -ChildPath "Docker\settings-store.json"

# Every failure exits 1, so chezmoi doesn't record the run as applied and tries again on the next apply
if ([System.Diagnostics.Process]::GetProcessesByName('Docker Desktop').Length -gt 0) {
    Write-Warning "Docker Desktop is running and would overwrite its settings. Quit it, then run chezmoi apply again."
    exit 1
}
if (-not (Test-Path -LiteralPath $settingsStore)) {
    Write-Warning "$settingsStore doesn't exist yet. Start Docker Desktop once, quit it, then run chezmoi apply again."
    exit 1
}
try {
    $desired = Get-Content -Path (Join-Path -Path $repoRoot -ChildPath "Config\Docker\settings.json") -Raw -ErrorAction Stop |
        ConvertFrom-Json -AsHashtable -ErrorAction Stop
    $current = Get-Content -LiteralPath $settingsStore -Raw -ErrorAction Stop | ConvertFrom-Json -AsHashtable -ErrorAction Stop
}
catch {
    Write-Warning "Can't read the Docker Desktop settings: $_"
    exit 1
}

$changed = @($desired.Keys | Where-Object { -not $current.Contains($_) -or $current[$_] -ne $desired[$_] })
if ($changed.Count -eq 0) {
    exit 0
}
foreach ($name in $changed) {
    $current[$name] = $desired[$name]
}
# Docker's own format: two-space indent, UTF-8 without BOM
[System.IO.File]::WriteAllText($settingsStore, ($current | ConvertTo-Json -Depth 20), [System.Text.UTF8Encoding]::new($false))
Write-Host "Docker Desktop settings: set $($changed -join ', ')." -ForegroundColor Green
exit 0
