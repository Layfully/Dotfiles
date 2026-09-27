<#
.SYNOPSIS
Installs missing PowerShell modules and removes superseded versions. chezmoi runs this when it changes and once a
week (home/.chezmoiscripts/run_onchange_after_30-powershell-modules.ps1.tmpl).

.DESCRIPTION
PSResourceGet (built into pwsh 7.4+) rather than PowerShellGet's Install-Module: it is much faster, and
PowerShellGet's Get-InstalledModule only sees the versions PowerShellGet installed itself. Updates come from
UniGetUI (its PowerShell 7 source), which installs each new version next to the old one - hence the cleanup.
#>
param(
    [switch] $Az  # Az PowerShell modules
)

$failures = 0

$psModules = @(
    "PSFzf"               # PSFzf to use fzf in PowerShell
    "CompletionPredictor" # PSReadLine predictions
    "posh-git"            # git tab completion
    "Terminal-Icons"      # terminal icons
)
if ($Az) { $psModules += "Az" }

#--- Missing modules ---
$missingModules = @($psModules | Where-Object { -not (Get-InstalledPSResource -Name $_ -Scope CurrentUser -ErrorAction SilentlyContinue) })
if ($missingModules) {
    if (-not (Get-PSResourceRepository -Name PSGallery).Trusted) { Set-PSResourceRepository -Name PSGallery -Trusted }
    foreach ($moduleName in $missingModules) {
        Write-Host "Installing module '$moduleName'..." -ForegroundColor Yellow
        Install-PSResource -Name $moduleName -Scope CurrentUser
        if (-not $?) { $failures++ }
    }
}

#--- Superseded versions ---
# Get-InstalledPSResource lists only modules installed from a repository (under Documents\PowerShell and
# Program Files\PowerShell), never the ones that ship with PowerShell 7 or Windows PowerShell 5.1 -
# deleting those would break them.
foreach ($module in Get-InstalledPSResource | Where-Object Type -eq Module | Group-Object -Property Name) {
    # Newest first. Version is a [version] (so 2.7.12 sorts above 2.7.9) and holds no prerelease label, so
    # a release is put above its own prereleases.
    $versions = @($module.Group | Sort-Object -Property Version, @{ Expression = { -not $_.Prerelease } } -Descending)
    $newest = $versions[0]
    $newestText = "$($newest.Version)$(if ($newest.Prerelease) { "-$($newest.Prerelease)" })"

    foreach ($olderVersion in $versions | Select-Object -Skip 1) {
        $versionText = "$($olderVersion.Version)$(if ($olderVersion.Prerelease) { "-$($olderVersion.Prerelease)" })"
        Write-Host "Uninstalling '$($module.Name)' $versionText (latest is $newestText)..." -ForegroundColor DarkYellow
        # -SkipDependencyCheck: otherwise a module another one (e.g. Az) depends on is refused, even though the
        # newest version, which stays, satisfies that dependency
        $scope = if ($olderVersion.InstalledLocation -like "$env:ProgramFiles\*") { 'AllUsers' } else { 'CurrentUser' }
        try {
            $olderVersion | Uninstall-PSResource -Scope $scope -SkipDependencyCheck -ErrorAction Stop
        }
        catch {
            # Usually because a PowerShell session still has that version loaded; the next apply tries again
            Write-Warning "Could not uninstall '$($module.Name)' ${versionText}: $($_.Exception.Message)"
        }
    }
}

exit [int]($failures -gt 0)
