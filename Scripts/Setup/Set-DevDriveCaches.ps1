<#
.SYNOPSIS
Points the package caches at the Dev Drive. chezmoi runs this on every apply (home/.chezmoiscripts/run_after_25-dev-drive.ps1.tmpl):
it only changes something when the variables don't match the devDrive answer.

.DESCRIPTION
A Dev Drive (ReFS, with Defender's performance mode) builds and restores faster, and keeps the caches off C:.
Sets user environment variables, so they hold for every tool and every Node version nvm switches to (a cache set
in a Node installation's own npmrc goes away with that version). What is already in the old caches stays there;
the caches fill up again on the Dev Drive as packages are restored. With -DevDrive none, it removes the variables
it set, so the tools go back to their default caches.
#>
param(
    # The Dev Drive, like D:, or none
    [Parameter(Mandatory)]
    [ValidatePattern('^([A-Za-z]:|none)$')]
    [string] $DevDrive
)

# Variable -> its folder under <drive>\packages
$caches = [ordered]@{
    NUGET_PACKAGES   = 'nuget'  # NuGet's global packages folder
    npm_config_cache = 'npm'    # npm's cache
}

# No %TOKENS% in these values, so SetEnvironmentVariable is safe here (unlike for PATH), and it tells running apps
# (Explorer, new terminals) about the change
if ($DevDrive -eq 'none') {
    foreach ($name in $caches.Keys) {
        # Only a value this script set: a cache pointed elsewhere by hand stays
        if ([Environment]::GetEnvironmentVariable($name, 'User') -match "^[A-Za-z]:\\packages\\$($caches[$name])$") {
            [Environment]::SetEnvironmentVariable($name, $null, 'User')
            Write-Host "Removed $name." -ForegroundColor Green
        }
    }
    exit 0
}

if (-not (Test-Path -LiteralPath "$DevDrive\")) {
    Write-Warning "The Dev Drive $DevDrive doesn't exist. Create it (Settings > System > Storage > Disks & volumes), or change devDrive with chezmoi edit-config."
    exit 1
}

foreach ($name in $caches.Keys) {
    $folder = "$DevDrive\packages\$($caches[$name])"
    $null = New-Item -ItemType Directory -Path $folder -Force
    if ([Environment]::GetEnvironmentVariable($name, 'User') -ne $folder) {
        [Environment]::SetEnvironmentVariable($name, $folder, 'User')
        Write-Host "Set $name to $folder." -ForegroundColor Green
    }
}
exit 0
