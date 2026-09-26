<#
.SYNOPSIS
Installs the VS Code extensions from the lists the pre-commit hook saves (Scripts\GitHooks\SaveVsCodeExtensions.ps1).
chezmoi runs this when one of those lists changes.

.DESCRIPTION
Config\VisualStudioCode\extensions is the base list (the private machine's). Work machines also install
extensions.work, the overlay: what the work machine has on top of the base list.
#>
param(
    [ValidateSet('private', 'work')]
    [string] $Role = 'private'
)

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\Setup -> repo root

# code.cmd rather than Code.exe, which doesn't support CLI flags like --list-extensions. VS Code may have been
# installed moments ago by winget, so it may not be on this session's PATH yet.
$codePath = (Get-Command code.cmd -ErrorAction SilentlyContinue).Source
if (-not $codePath) {
    $codePath = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",  # per-user install (default)
        "C:\Program Files\Microsoft VS Code\bin\code.cmd"             # system-wide install
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $codePath) {
    Write-Warning "VS Code CLI (code.cmd) not found. Skipping the extension install."
    exit 1
}

$listFiles = @(Join-Path -Path $repoRoot -ChildPath "Config\VisualStudioCode\extensions")
if ($Role -eq 'work') { $listFiles += Join-Path -Path $repoRoot -ChildPath "Config\VisualStudioCode\extensions.work" }

# Extension IDs are case-insensitive, and -notin compares case-insensitively
$installedExtensions = & $codePath --list-extensions
$missingExtensions = $listFiles | Where-Object { Test-Path -LiteralPath $_ } |
    ForEach-Object { Get-Content -LiteralPath $_ } |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and $_ -notin $installedExtensions } |
    Select-Object -Unique

if (-not $missingExtensions) {
    Write-Host "All VS Code extensions are installed." -ForegroundColor Green
    exit 0
}

Write-Host "Installing $(@($missingExtensions).Count) missing VS Code extension(s)..."
# One code.cmd call for all of them: every launch of the CLI takes a few seconds
$installArguments = $missingExtensions | ForEach-Object { '--install-extension', $_ }
& $codePath @installArguments
exit [int]($LASTEXITCODE -ne 0)
