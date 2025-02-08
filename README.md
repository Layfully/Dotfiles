# WindowsSetup
 A collection of personalized configuration files for package managers, terminals, Windows settings, and keyboard layouts. Curated over time to optimize new machine setup, this repo helps you achieve a fast and efficient personalized experience.

## Git Hooks
This repository uses Git hooks to automate certain tasks (e.g. managing PowerToys backups, automatic vscode extensions backup).  To enable these hooks, you *must* run the following command within the repository *after* cloning:

```bash
git config --local core.hooksPath .githooks
```

CTRL + F - run fuzzy finder
CTRL + R - run fuzzy finder on powershell command history
ALT + C - use fuzzy finder to switch directory
