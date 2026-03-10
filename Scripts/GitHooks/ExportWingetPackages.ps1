# Exports the current machine's winget package list to the UniGetUI folder.
# The bundle is named after the computer so multi-machine setups don't conflict.
# On machines whose filename is gitignored (e.g. the work machine), the git add in
# the pre-commit hook is a no-op — only the private machine's bundle gets tracked.
$bundlePath = "$env:USERPROFILE\Dotfiles\UniGetUI\$env:COMPUTERNAME installed packages.ubundle"
winget export -o $bundlePath --accept-source-agreements
