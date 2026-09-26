<#
.SYNOPSIS
Applies Config\PowerToys\settings.json with PowerToys.DSC.exe. chezmoi runs this when that file changes.

.DESCRIPTION
The file maps each PowerToys.DSC.exe module name (`PowerToys.DSC.exe modules --resource settings`) to the
settings it should have. PowerToys merges the App (general) entry into what is there, so that one lists only
what matters. Every other module's settings are compared and replaced as a whole: add one as the full
"settings" object that `PowerToys.DSC.exe get --module <Name> --resource settings` prints.

PowerToys' PowerShell DSC module, the one `winget configure` could use, doesn't find the installation in
PowerToys 0.101 (it compares DisplayVersion 0.101.2362 with the registry's 0.101.2362.0), hence the exe.
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
$powerToysSettings = Get-Content -Path (Join-Path -Path $repoRoot -ChildPath "Config\PowerToys\settings.json") -Raw | ConvertFrom-Json -AsHashtable
foreach ($moduleName in $powerToysSettings.Keys) {
    Write-Host "Applying PowerToys settings: $moduleName..."
    $desiredState = @{ settings = $powerToysSettings[$moduleName] } | ConvertTo-Json -Depth 20 -Compress
    & $powerToysDsc set --module $moduleName --resource settings --input $desiredState | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Warning "PowerToys settings: $moduleName failed (exit code $LASTEXITCODE)."; $failures++ }
}
exit [int]($failures -gt 0)
