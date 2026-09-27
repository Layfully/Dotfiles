<#
.SYNOPSIS
Creates the links chezmoi can't manage itself. chezmoi runs this on every `chezmoi apply`.

.DESCRIPTION
- $PROFILE lives in Documents\PowerShell, and OneDrive moves Documents on the work machine, so the path is only
  known at run time. It gets a stub that loads ~/.config/powershell/user_profile.ps1, which chezmoi links into
  the repo.
- Retires ~/.gitconfig, which the old Tools.ps1 set up: git reads it ahead of ~/.config/git/config.
- Enables the repo's git hooks.
#>

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\Setup -> repo root
$failures = 0

#--- PowerShell profile ---
# A one-line stub that dot-sources the real profile, not a symlink: OneDrive, which holds Documents on the work
# machine, doesn't handle symlinks. The profile finds its own folder from $PSCommandPath, which is its path
# when dot-sourced, so it works the same either way.
$profileStub = "# Written by the dotfiles setup (Scripts/Setup/Set-MachineLinks.ps1). The profile itself is in the repo.`n" +
               ". `"`$HOME\.config\powershell\user_profile.ps1`"`n"
try {
    $existingProfile = Get-Item -LiteralPath $PROFILE -Force -ErrorAction SilentlyContinue
    if ($existingProfile.LinkType) {
        # What earlier versions of this script made
        $existingProfile.Delete()
    }
    elseif ($existingProfile -and [IO.File]::ReadAllText($PROFILE) -ne $profileStub) {
        $backupPath = "$PROFILE.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
        Write-Warning "'$PROFILE' already exists. Moving it to '$backupPath'."
        Move-Item -LiteralPath $PROFILE -Destination $backupPath -ErrorAction Stop
    }
    if (-not [IO.File]::Exists($PROFILE)) {
        $null = New-Item -ItemType Directory -Path (Split-Path -Path $PROFILE) -Force
        [IO.File]::WriteAllText($PROFILE, $profileStub)
        Write-Host "Wrote the profile stub '$PROFILE'." -ForegroundColor Green
    }
}
catch { Write-Warning "Writing the PowerShell profile stub failed: $($_.Exception.Message)"; $failures++ }

#--- Old ~/.gitconfig ---
# The git config is ~/.config/git/config now. Git would still read a ~/.gitconfig, ahead of it, and
# `git config --global` would write there.
$oldGitConfig = Get-Item -LiteralPath (Join-Path -Path $HOME -ChildPath '.gitconfig') -Force -ErrorAction SilentlyContinue
if ($oldGitConfig.LinkType) {
    $oldGitConfig.Delete()
    Write-Host "Removed the old link '$($oldGitConfig.FullName)'." -ForegroundColor Green
}
elseif ($oldGitConfig) {
    $backupPath = "$($oldGitConfig.FullName).$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
    Write-Warning "'$($oldGitConfig.FullName)' would override ~/.config/git/config. Moving it to '$backupPath' - merge what you need into the repo."
    Move-Item -LiteralPath $oldGitConfig.FullName -Destination $backupPath
}

#--- Git hooks ---
# The pre-commit hook keeps the VS Code extension lists up to date
if ((git -C $repoRoot config --local core.hooksPath) -ne '.githooks') {
    git -C $repoRoot config --local core.hooksPath .githooks
    if ($LASTEXITCODE -eq 0) { Write-Host "Git hooks enabled (core.hooksPath = .githooks)." -ForegroundColor Green }
    else { Write-Warning "Enabling the git hooks failed (exit code $LASTEXITCODE)."; $failures++ }
}

# Non-zero makes chezmoi report the failure; this script runs again on the next apply anyway
exit [int]($failures -gt 0)
