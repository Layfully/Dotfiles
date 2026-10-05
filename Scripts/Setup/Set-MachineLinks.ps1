<#
.SYNOPSIS
Creates the links chezmoi can't manage itself. chezmoi runs this on every `chezmoi apply`.

.DESCRIPTION
Writes the $PROFILE stub (see the README's What Gets Linked) and enables the repo's git hooks.
#>

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\Setup -> repo root
$failures = 0

#--- PowerShell profile ---
# The profile finds its own folder from $PSCommandPath, which is its path when dot-sourced, so a stub works
# the same as a link would.
$profileStub = "# Written by the dotfiles setup (Scripts/Setup/Set-MachineLinks.ps1). The profile itself is in the repo.`n" +
               ". `"`$HOME\.config\powershell\user_profile.ps1`"`n"
try {
    if ([IO.File]::Exists($PROFILE) -and [IO.File]::ReadAllText($PROFILE) -ne $profileStub) {
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

#--- Git hooks ---
# The pre-commit hook keeps the VS Code extension lists up to date
if ((git -C $repoRoot config --local core.hooksPath) -ne '.githooks') {
    git -C $repoRoot config --local core.hooksPath .githooks
    if ($LASTEXITCODE -eq 0) { Write-Host "Git hooks enabled (core.hooksPath = .githooks)." -ForegroundColor Green }
    else { Write-Warning "Enabling the git hooks failed (exit code $LASTEXITCODE)."; $failures++ }
}

# Non-zero makes chezmoi report the failure; this script runs again on the next apply anyway
exit [int]($failures -gt 0)
