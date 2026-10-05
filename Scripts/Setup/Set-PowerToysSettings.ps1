<#
.SYNOPSIS
Applies Config\PowerToys\settings.json with PowerToys.DSC.exe. chezmoi runs this when that file or this script changes.

.DESCRIPTION
The file's format, and why this uses the exe rather than PowerToys' DSC module: the README's PowerToys Settings.
#>

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\Setup -> repo root

$powerToysDsc = @(
    "$env:LOCALAPPDATA\PowerToys\PowerToys.DSC.exe",  # per-user install
    "$env:ProgramFiles\PowerToys\PowerToys.DSC.exe"   # machine-wide install
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $powerToysDsc) {
    Write-Warning "PowerToys.DSC.exe not found. Skipping the PowerToys settings."
    exit 1
}

$failures = 0
# A missing or broken file must fail the run: otherwise chezmoi records it as applied and doesn't try again
try {
    $powerToysSettings = Get-Content -Path (Join-Path -Path $repoRoot -ChildPath "Config\PowerToys\settings.json") -Raw -ErrorAction Stop |
        ConvertFrom-Json -AsHashtable -ErrorAction Stop
}
catch {
    Write-Warning "Can't read Config\PowerToys\settings.json: $_"
    exit 1
}
foreach ($moduleName in $powerToysSettings.Keys) {
    Write-Host "Applying PowerToys settings: $moduleName..."
    $desiredState = @{ settings = $powerToysSettings[$moduleName] } | ConvertTo-Json -Depth 20 -Compress
    & $powerToysDsc set --module $moduleName --resource settings --input $desiredState | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Warning "PowerToys settings: $moduleName failed (exit code $LASTEXITCODE)."; $failures++ }
}
exit [int]($failures -gt 0)
