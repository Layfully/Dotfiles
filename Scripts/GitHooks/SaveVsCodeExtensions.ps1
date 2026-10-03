# Saves the list of installed VS Code extensions for reinstall on a new machine.
#
# We resolve code.cmd explicitly instead of calling `code` directly because git hooks
# run in a minimal shell environment where PATH may not include the VS Code bin directory.
# Calling the raw Code.exe fails since it doesn't support CLI flags like --list-extensions -
# only the code.cmd wrapper does. We try PATH first, then fall back to known install locations.
$codePath = (Get-Command code.cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue)
if (-not $codePath) {
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",  # per-user install (default)
        "C:\Program Files\Microsoft VS Code\bin\code.cmd"             # system-wide install
    )
    $codePath = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $codePath) { Write-Error "VS Code CLI (code.cmd) not found. Skipping extension backup."; exit 1 }

$repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent  # Scripts\GitHooks -> repo root
$listFolder = "$repoRoot\Config\VisualStudioCode"

# The machine's role is in chezmoi's config (written by home/.chezmoi.toml.tmpl). Without it, guessing could
# overwrite the other machine's list, so nothing is written.
$chezmoiConfig = "$env:USERPROFILE\.config\chezmoi\chezmoi.toml"
$roleLine = if (Test-Path $chezmoiConfig) { Select-String -Path $chezmoiConfig -Pattern '^\s*role\s*=\s*"(\w+)"' | Select-Object -First 1 }
if (-not $roleLine) { Write-Host "No role in '$chezmoiConfig' (run chezmoi init). Skipping the VS Code extension list."; exit 0 }
$role = $roleLine.Matches[0].Groups[1].Value

$extensions = & $codePath --list-extensions
# A failing CLI (VS Code updating, say) would otherwise empty the list, and the next "stage all" would commit that
if ($LASTEXITCODE -ne 0 -or -not $extensions) {
    Write-Host "code --list-extensions returned nothing (exit code $LASTEXITCODE). Skipping the VS Code extension list."
    exit 0
}
if ($role -eq 'work') {
    # The work list is an overlay: only what the work machine has on top of the base (private) list.
    # Extension IDs are case-insensitive, and -notin compares case-insensitively.
    $baseExtensions = Get-Content "$listFolder\extensions" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $extensions = $extensions | Where-Object { $_ -notin $baseExtensions }
    $listName = 'extensions.work'
}
else {
    $listName = 'extensions'
}
# WriteAllText instead of Out-File: in Windows PowerShell 5.1, Out-File writes CRLF and a UTF-8 BOM, and
# .gitattributes checks text out as LF, so git would warn about this file after every commit
[IO.File]::WriteAllText("$listFolder\$listName", (($extensions -join "`n") + "`n"))
