# Saves the list of installed VS Code extensions for reinstall on a new machine.
#
# We resolve code.cmd explicitly instead of calling `code` directly because git hooks
# run in a minimal shell environment where PATH may not include the VS Code bin directory.
# Calling the raw Code.exe fails since it doesn't support CLI flags like --list-extensions —
# only the code.cmd wrapper does. We try PATH first, then fall back to known install locations.
$codePath = (Get-Command code.cmd -ErrorAction SilentlyContinue)?.Source
if (-not $codePath) {
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",  # per-user install (default)
        "C:\Program Files\Microsoft VS Code\bin\code.cmd"             # system-wide install
    )
    $codePath = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $codePath) { Write-Error "VS Code CLI (code.cmd) not found. Skipping extension backup."; exit 1 }

& $codePath --list-extensions > "$env:USERPROFILE\Dotfiles\Config\VisualStudioCode\extensions"
