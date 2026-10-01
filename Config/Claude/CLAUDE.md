# About me and my machines

- I'm Adrian Gaborek, a .NET developer. Windows 11, PowerShell 7 as my shell (Git Bash is there too); some work happens in WSL (Ubuntu).
- My machine setup is a chezmoi dotfiles repo (`chezmoi source-path` prints where). The configs under my home folder (git, VS Code, Windows Terminal, lazygit, PowerShell profile, Claude Code's settings and this file) are symlinks into it, so change the repo's file, not a copy. Something a machine should keep (a tool, a setting, an environment variable) belongs in that repo, not in a one-off change; suggest it there. Its CLAUDE.md has the rules for changing it.
- Git picks my identity from the remote (includes in `~/.config/git/config`): never set `user.name` or `user.email` in a repo or with `git config --global`. Pulls rebase. I review and commit with lazygit: don't commit or push unless I ask.
- The NuGet and npm caches are on a Dev Drive (`NUGET_PACKAGES`, `npm_config_cache`, set by the dotfiles); don't point them anywhere else.
- Repositories have their own CLAUDE.md, including how to write commit messages there; follow it.

@~/.claude/CLAUDE.work.md
