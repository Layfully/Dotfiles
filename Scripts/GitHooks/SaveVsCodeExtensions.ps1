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
# WriteAllText instead of Out-File: in Windows PowerShell 5.1, Out-File writes CRLF and a UTF-8 BOM, and
# .gitattributes checks text out as LF, so git would warn about this file after every commit
$extensions = & $codePath --list-extensions
# Work machines (DEV-WNW-* hostnames, the convention .gitignore uses too) keep a list of their own, so
# work-only extensions stay out of the private list and the other way round. Tools.ps1 picks the same way.
$listName = if ($env:COMPUTERNAME -like 'DEV-WNW-*') { 'extensions.work' } else { 'extensions' }
[IO.File]::WriteAllText("$repoRoot\Config\VisualStudioCode\$listName", (($extensions -join "`n") + "`n"))
