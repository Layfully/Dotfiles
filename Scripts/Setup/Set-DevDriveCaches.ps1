<#
.SYNOPSIS
Points the package caches at the Dev Drive. chezmoi runs this when it or the devDrive answer changes
(home/.chezmoiscripts/run_onchange_after_25-dev-drive.ps1.tmpl).

.DESCRIPTION
A Dev Drive (ReFS, with Defender's performance mode) builds and restores faster, and keeps the caches off C:.
Sets user environment variables, so they hold for every tool and every Node version nvm switches to (a cache set
in a Node installation's own npmrc goes away with that version). What is already in the old caches stays there;
the caches fill up again on the Dev Drive as packages are restored.
#>
param(
    # The Dev Drive, like D:
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z]:$')]
    [string] $DevDrive
)

if (-not (Test-Path -LiteralPath "$DevDrive\")) {
    Write-Warning "The Dev Drive $DevDrive doesn't exist. Create it (Settings > System > Storage > Disks & volumes), or change devDrive with chezmoi edit-config."
    exit 1
}

# Variable -> folder on the Dev Drive
$caches = [ordered]@{
    NUGET_PACKAGES   = "$DevDrive\packages\nuget"  # NuGet's global packages folder
    npm_config_cache = "$DevDrive\packages\npm"    # npm's cache
}
foreach ($name in $caches.Keys) {
    $null = New-Item -ItemType Directory -Path $caches[$name] -Force
    # No %TOKENS% in these values, so SetEnvironmentVariable is safe here (unlike for PATH), and it tells running
    # apps (Explorer, new terminals) about the change
    if ([Environment]::GetEnvironmentVariable($name, 'User') -ne $caches[$name]) {
        [Environment]::SetEnvironmentVariable($name, $caches[$name], 'User')
        Write-Host "Set $name to $($caches[$name])." -ForegroundColor Green
    }
}
exit 0
