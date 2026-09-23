#Startup
# Nothing before the first prompt uses cmdlets from the Microsoft.PowerShell.Management or Utility
# modules (Get-Item, Test-Path, Set-Alias, Register-EngineEvent...) - nor does the patched oh-my-posh
# prompt below - so those modules (~10ms each) load later, on first use or when the shell is idle.
# The & { } scope keeps the helper variables out of the session.
& {
    # $PROFILE is a symlink into the repo - resolve it so repo-relative files can be found
    $profileFile = [IO.FileInfo]::new($PSCommandPath)
    $global:DotfilesConfig = ($profileFile.ResolveLinkTarget($true) ?? $profileFile).DirectoryName

    # oh-my-posh and zoxide launch their exe on every start just to print an init script. Cache that
    # script (patched, see below) and reuse it while the exe and input files are unchanged. Line 1 records
    # their paths and timestamps - the exe's path included, so a normal start needs no PATH search.
    function global:Get-CachedInitScript([string] $Name, [string[]] $Inputs, [scriptblock] $FindExe, [scriptblock] $Generate) {
        $cacheFile = [IO.Path]::Combine($env:LOCALAPPDATA, 'PowerShellProfileCache', "$Name.ps1")
        $makeKey = {
            param([string] $Exe)
            $key = '# key: v4' # bump when a $Generate block changes
            foreach ($path in @($Exe) + $Inputs) {
                $file = [IO.FileInfo]::new($path)
                if ($file.Exists -and $file.Attributes -band [IO.FileAttributes]::ReparsePoint) { $file = $file.ResolveLinkTarget($true) }
                $key += "|$path*$($file.LastWriteTimeUtc.Ticks)"
            }
            $key
        }
        if ([IO.File]::Exists($cacheFile)) {
            $text = [IO.File]::ReadAllText($cacheFile)
            # char (ordinal) searches: string overloads are culture-aware, and loading the collation data costs ~6ms
            $firstLine = $text.Substring(0, [Math]::Max(0, $text.IndexOf([char]10)))
            $fields = $firstLine.Split([char]'|')
            if ($fields.Count -gt 1 -and $firstLine.Equals((& $makeKey $fields[1].Split([char]'*')[0]))) { return $text }
        }
        $exe = & $FindExe
        if (-not $exe) { return }
        $text = (& $makeKey $exe) + "`n" + ((& $Generate $exe) -join "`n")
        $null = [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($cacheFile))
        [IO.File]::WriteAllText($cacheFile, $text)
        $text
    }

    #Prompt
    # Local copy of the built-in cloud-context theme minus the cloud segments (kubectl, aws, az, gcp...)
    # that never show here. Loading a theme by name makes oh-my-posh check GitHub for updates (~300ms),
    # and the az segments make every prompt call Get-AzContext.
    $ompTheme = [IO.Path]::Combine($global:DotfilesConfig, 'oh-my-posh', 'cloud-context.omp.json')
    $ompInit = if ([IO.File]::Exists($ompTheme)) {
        Get-CachedInitScript 'oh-my-posh' $ompTheme { (Get-Command oh-my-posh -CommandType Application -TotalCount 1 -ErrorAction Ignore).Source } {
            param($exe)
            # `init` prints "& '<init script>'" - cache the script itself, as oh-my-posh deletes old copies
            $init = (& $exe init pwsh --config $ompTheme) -join "`n"
            if ($init -notmatch "^& '(.+)'$") { return $init }
            $code = [IO.File]::ReadAllText($Matches[1])
            $secondary = ((& $exe print secondary --shell=pwsh --config $ompTheme) -join "`n").Replace("'", "''")
            $gitCmd = (Get-Command git -CommandType Application -TotalCount 1 -ErrorAction Ignore).Source
            $gitBin = if ($gitCmd) { [IO.Path]::GetFullPath([IO.Path]::Combine($gitCmd, '..', '..', 'mingw64', 'bin')) }

            # Literal find/replace pairs for oh-my-posh's generated code. A pair that stops matching (after an
            # oh-my-posh upgrade) is simply skipped, leaving the original code in place.
            $patches = @(
                # A process launch just to make a session GUID...
                '(& $global:_ompExecutable get uuid)'
                '([guid]::NewGuid().ToString())'
                # ...and one at every start to render the continuation prompt, which is static (~60ms)
                '(Invoke-Utf8Posh @("print", "secondary", "--shell=$script:ShellName")) -join "`n"'
                "'$secondary'"
                # Management/Utility cmdlets and pipelines in the per-prompt code -> engine/.NET equivalents
                'Get-Location -Stack'
                '$ExecutionContext.SessionState.Path.LocationStack($null)'
                'New-Object System.Diagnostics.Process'
                '[System.Diagnostics.Process]::new()'
                '$Arguments | ForEach-Object -Process { $StartInfo.ArgumentList.Add($_) }'
                'foreach ($argument in $Arguments) { $StartInfo.ArgumentList.Add($argument) }'
                '(Test-Path -LiteralPath $PWD)'
                '[System.IO.Directory]::Exists($PWD.ProviderPath)'
                # Measure-Object plus a PSReadLine call on every prompt -> count the lines, set only on change
                'Set-PSReadLineOption -ExtraPromptLineCount (($output | Measure-Object -Line).Lines - 1)'
                '$lineCount = if ($output) { $output.Split("`n").Count - [int]$output.EndsWith("`n") } else { 0 }; if ($lineCount - 1 -ne $script:ExtraPromptLineCount) { $script:ExtraPromptLineCount = $lineCount - 1; Set-PSReadLineOption -ExtraPromptLineCount $script:ExtraPromptLineCount }'
            )
            $gitPathLine = ''
            if ($gitBin -and [IO.File]::Exists([IO.Path]::Combine($gitBin, 'git.exe'))) {
                # Let the git segment run Git's real binary rather than its cmd\git.exe launcher, which
                # starts it as a second process (~10ms per prompt in a repo). Only oh-my-posh's PATH changes.
                $gitPathLine = "`$StartInfo.Environment['PATH'] = '$gitBin;' + `$env:PATH"
                $patches += '$StartInfo.UseShellExecute = $false'
                $patches += "`$StartInfo.UseShellExecute = `$false; $gitPathLine"
            }

            # Render the first prompt at init, in parallel with the rest of startup (~50ms saved). The prompt
            # function only uses it if nothing that prompt depends on has changed in between.
            $prefetch = @'
$env:POSH_SESSION_ID = ([guid]::NewGuid().ToString())
# (Added by user_profile.ps1) Start rendering the first prompt now - see Get-PoshFirstPrompt
if (-not [Console]::IsOutputRedirected -and $PWD.Provider.Name -eq 'FileSystem') {
    # the environment oh-my-posh-core sets up below, which the render needs
    $env:POWERLINE_COMMAND = 'oh-my-posh'
    $env:POSH_SHELL = 'pwsh'
    $env:POSH_SHELL_VERSION = $PSVersionTable.PSVersion.ToString()
    $env:CONDA_PROMPT_MODIFIER = $false
    $env:POSH_THEME = 'THEME_PATH'
    $width = $Host.UI.RawUI.WindowSize.Width
    if (-not $width) { $width = 0 }
    $env:POSH_CURSOR_LINE = $Host.UI.RawUI.CursorPosition.Y + 1
    $env:POSH_CURSOR_COLUMN = $Host.UI.RawUI.CursorPosition.X + 1
    # same arguments Get-PoshPrompt passes for a session's first prompt
    $StartInfo = [System.Diagnostics.ProcessStartInfo]::new($global:_ompExecutable)
    foreach ($argument in 'print', 'primary', '--save-cache', '--shell=pwsh', "--shell-version=$env:POSH_SHELL_VERSION", '--status=0', '--no-status=True', '--execution-time=0', '--pswd=', '--stack-count=0', "--terminal-width=$width", '--job-count=0') {
        $StartInfo.ArgumentList.Add($argument)
    }
    $StartInfo.StandardErrorEncoding = $StartInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $StartInfo.RedirectStandardError = $StartInfo.RedirectStandardInput = $StartInfo.RedirectStandardOutput = $true
    $StartInfo.UseShellExecute = $false
    $StartInfo.CreateNoWindow = $true
    $StartInfo.WorkingDirectory = $PWD.ProviderPath
    GIT_PATH_LINE
    $process = [System.Diagnostics.Process]::Start($StartInfo)
    $global:_ompFirstPrompt = @{
        Process   = $process
        Stdout    = $process.StandardOutput.ReadToEndAsync()
        Stderr    = $process.StandardError.ReadToEndAsync()
        Directory = $PWD.ProviderPath
        Width     = $width
    }
}
'@.Replace('THEME_PATH', [IO.Path]::GetFullPath($ompTheme).Replace("'", "''")).Replace('GIT_PATH_LINE', $gitPathLine)
            $consumer = @'
    # (Added by user_profile.ps1) Use the first prompt rendered at init, unless something it depends on changed
    function Get-PoshFirstPrompt {
        $first = $global:_ompFirstPrompt
        $global:_ompFirstPrompt = $null
        $first.Process.WaitForExit()
        $stdout = $first.Stdout.Result
        $stderr = $first.Stderr.Result.Trim()
        $first.Process.Dispose()
        if ($script:PromptType -ne 'primary' -or -not $script:NoExitCode -or $PWD.ProviderPath -ne $first.Directory -or
            (Get-TerminalWidth) -ne $first.Width -or (Get-PoshStackCount) -ne 0) {
            return Get-PoshPrompt $script:PromptType
        }
        if ($stderr) {
            $Host.UI.WriteErrorLine($stderr)
        }
        $stdout
    }

    function Get-PoshPrompt {
'@
            $patches += @(
                # (these anchor on text the uuid patch above has already produced)
                '$env:POSH_SESSION_ID = ([guid]::NewGuid().ToString())'
                $prefetch.TrimEnd()
                '    function Get-PoshPrompt {'
                $consumer.TrimEnd()
                '$output = Get-PoshPrompt $script:PromptType'
                '$output = if ($global:_ompFirstPrompt) { Get-PoshFirstPrompt } else { Get-PoshPrompt $script:PromptType }'
            )
            for ($i = 0; $i -lt $patches.Count; $i += 2) { $code = $code.Replace($patches[$i], $patches[$i + 1]) }
            # The theme-path check at init uses Test-Path/Resolve-Path (Management) too
            $code -replace "\(Test-Path -LiteralPath ('[^']*')\)", '([System.IO.File]::Exists($1))' -replace "\(Resolve-Path -Path ('[^']*')\)\.ProviderPath", '[System.IO.Path]::GetFullPath($1)'
        }
    }
    if ($ompInit) { & ([scriptblock]::Create($ompInit)) }
    elseif (Get-Command oh-my-posh -CommandType Application -ErrorAction Ignore) {
        oh-my-posh init pwsh --config 'cloud-context' | Invoke-Expression
    }

    #zoxide (z / zi for fast directory jumping)
    # Loaded on the first idle tick (see #Deferred setup) - after oh-my-posh, since it wraps the prompt.
    # If z/zi is typed before that, these stand-ins load it first. Once loaded, zoxide's own z/zi
    # aliases take over (aliases win over functions). Its init script defines everything globally.
    function global:Import-ZoxideOnDemand {
        if ($global:ZoxideLoaded) { return }
        $global:ZoxideLoaded = $true
        $init = Get-CachedInitScript 'zoxide' @() { (Get-Command zoxide -CommandType Application -TotalCount 1 -ErrorAction Ignore).Source } {
            param($exe)
            $code = (& $exe init powershell) -join "`n"
            # Record each new directory without waiting for `zoxide add` to finish (~20ms on every cd),
            # and read the location without the Management module's Get-Location
            $asyncAdd = @'
function global:__zoxide_add_async([string] $Path) {
    $startInfo = [System.Diagnostics.ProcessStartInfo]::new('ZOXIDE_EXE')
    foreach ($argument in 'add', '--', $Path) { $startInfo.ArgumentList.Add($argument) }
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    [System.Diagnostics.Process]::Start($startInfo).Dispose()
}
'@.Replace('ZOXIDE_EXE', $exe)
            $code = $code.Replace('zoxide add "--" $result', '__zoxide_add_async $result')
            $code = $code.Replace('Microsoft.PowerShell.Management\Get-Location', '$ExecutionContext.SessionState.Path.CurrentLocation')
            $asyncAdd + "`n" + $code
        }
        if ($init) { . ([scriptblock]::Create($init)) }
        $null = $ExecutionContext.InvokeProvider.Item.Remove('Function:\Get-CachedInitScript', $false)
    }
    function global:z { Import-ZoxideOnDemand; __zoxide_z @args }
    function global:zi { Import-ZoxideOnDemand; __zoxide_zi @args }
}

#PSReadLine
# EditMode (Windows) and PredictionViewStyle (InlineView) are left at their defaults. Never set
# -EditMode below custom key bindings: it resets all bindings to that mode's defaults.
# Predictions need a real console - with redirected output (VS Code tasks, scripts, tools) enabling
# them throws an error that costs ~150ms to write out.
if ([Console]::IsOutputRedirected) { Set-PSReadLineOption -BellStyle None }
else { Set-PSReadLineOption -BellStyle None -PredictionSource HistoryAndPlugin }
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

#Lazy-loaded modules
# Importing these at startup costs ~3s, and importing them when the shell goes idle freezes input
# for up to ~1s each. Instead each one loads the first time it is actually used.

# PSFzf: on the first fzf key chord (or via module autoload when an fzf alias like `fe` is used)
function global:Import-PSFzfOnDemand {
    if (-not $global:PSFzfConfigured) {
        Import-Module PSFzf -Global
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
        $global:PSFzfConfigured = $true
    }
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -BriefDescription 'PSFzf (loads on first use)' -ScriptBlock { Import-PSFzfOnDemand; Invoke-FzfPsReadlineHandlerProvider }
Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -BriefDescription 'PSFzf (loads on first use)' -ScriptBlock { Import-PSFzfOnDemand; Invoke-FzfPsReadlineHandlerHistory }
Set-PSReadLineKeyHandler -Chord 'Alt+c' -BriefDescription 'PSFzf (loads on first use)' -ScriptBlock { Import-PSFzfOnDemand; Invoke-FzfPsReadlineHandlerSetLocation }

# posh-git: on the first `git <Tab>`. Importing it registers its own completer, which replaces this one.
# (Only kept for git tab completion - the prompt's git info comes from oh-my-posh.)
Register-ArgumentCompleter -Native -CommandName git, g -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    Import-Module posh-git -Global
    # Same input posh-git's own completer builds: the command line up to the cursor, space-padded
    $padLength = $cursorPosition - $commandAst.Extent.StartOffset
    Expand-GitCommand $commandAst.ToString().PadRight($padLength, ' ').Substring(0, $padLength)
}

# Terminal-Icons: just before the first directory listing
$ExecutionContext.InvokeCommand.PreCommandLookupAction = {
    param($commandName, $eventArgs)
    if ($commandName -in 'ls', 'll', 'dir', 'gci', 'Get-ChildItem') {
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
        Import-Module Terminal-Icons -Global
    }
}

#Deferred setup
# Not needed for the first prompt: one step per PSReadLine idle tick. Those come every 300ms while the
# input line is empty, so a step never interrupts typing. (The engine API is used instead of
# Register-EngineEvent, which would load the Utility module at startup.)
$global:DeferredProfileStep = 0
$null = $ExecutionContext.Events.SubscribeEvent($null, $null, 'PowerShell.OnIdle', $null, {
    try {
        switch ($global:DeferredProfileStep++) {
            0 { Import-ZoxideOnDemand } # first, so directory tracking starts early
            1 { Import-Module CompletionPredictor -Global }
            2 { . ([IO.Path]::Combine($global:DotfilesConfig, 'user_profile_autopairing.ps1')) }
        }
    }
    catch { Write-Warning "Deferred profile step failed: $_" }
    if ($global:DeferredProfileStep -gt 2) {
        $ExecutionContext.Events.UnsubscribeEvent($EventSubscriber)
        $ExecutionContext.SessionState.PSVariable.Remove('global:DeferredProfileStep')
    }
}, $false, $false)

#Cheatsheet
function cheat {
    $c = @{ Header = 'Cyan'; Key = 'Yellow'; Desc = 'Gray' }
    function row($key, $desc) {
        Write-Host "  " -NoNewline
        Write-Host ("{0,-18}" -f $key) -ForegroundColor $c.Key -NoNewline
        Write-Host $desc -ForegroundColor $c.Desc
    }
    function section($title) {
        Write-Host ""
        Write-Host "  $title" -ForegroundColor $c.Header
        Write-Host ("  " + "-" * ($title.Length)) -ForegroundColor DarkGray
    }

    section "Navigation"
    row "z <partial>"      "Jump to frecent directory (zoxide)"
    row "fd"               "Fuzzy cd into any directory"
    row "Alt+C"            "Fuzzy cd (inline, fzf)"

    section "Search & Edit"
    row "Ctrl+F"           "Fuzzy find file (fzf)"
    row "fe"               "Fuzzy find and open file in editor"
    row "Ctrl+R"           "Fuzzy search command history"
    row "fh"               "Fuzzy browse and run history entry"

    section "Git"
    row "lg"               "lazygit (full terminal git UI)"
    row "gs"               "git status"
    row "gl"               "git pull"
    row "gp"               "git push"
    row "gf"               "git fetch origin"
    row "g"                "git (short alias)"
    row "fgs"              "Fuzzy git status (stage/diff files)"
    row "tig"              "Git history browser (TUI)"

    section "Process & System"
    row "fkill"            "Fuzzy kill a running process"
    row "fz  or  zi"       "Fuzzy jump (zoxide via fzf)"
    row "which <cmd>"      "Show full path of a command"

    section "PSReadLine"
    row "Ctrl+D"           "Delete character (like Unix)"
    row "UpArrow"          "Search history backwards"
    row "DownArrow"        "Search history forwards"
    row "'  or  ("         "Auto-closes matching quote/brace"

    Write-Host ""
}

#Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Invoke-* rather than Get-* so the deferred posh-git import can't overwrite these (it exports Get-GitStatus)
function Invoke-GitStatus { & git status $args }

function Invoke-GitPull { & git pull $args }

function Invoke-GitPush { & git push $args }

function Invoke-GitFetch { & git fetch origin $args}

function sanitize {
    param(
        [string] $RootPath = 'D:\AI',
        [switch] $DryRun
    )
    $arguments = @('-ExecutionPolicy', 'Bypass', '-File', 'D:\AI\APM\Sanitize-LocalRepo_generic.ps1', '-RootPath', $RootPath)
    if ($DryRun) { $arguments += '-DryRun' }
    powershell @arguments
}

#Alias
# ${alias:name} = ... rather than Set-Alias, which would load the Utility module at startup (~10ms).
# The read-only built-ins gl and gp have to be forced through the provider API.
${alias:vim} = 'nvim'
${alias:ll} = 'ls'
${alias:g} = 'git'
${alias:grep} = 'findstr'
${alias:tig} = 'C:\Program Files\Git\usr\bin\tig.exe'
${alias:less} = 'C:\Program Files\Git\usr\bin\less.exe'
${alias:fz} = 'zi'
${alias:fgs} = 'Invoke-FuzzyGitStatus'
${alias:fe} = 'Invoke-FuzzyEdit'
${alias:fh} = 'Invoke-FuzzyHistory'
${alias:fkill} = 'Invoke-FuzzyKillProcess'
${alias:fd} = 'Invoke-FuzzySetLocation'
${alias:gs} = 'Invoke-GitStatus'
${alias:gf} = 'Invoke-GitFetch'
${alias:lg} = 'lazygit'
$null = $ExecutionContext.InvokeProvider.Item.Set('Alias:\gl', 'Invoke-GitPull', $true, $true)
$null = $ExecutionContext.InvokeProvider.Item.Set('Alias:\gp', 'Invoke-GitPush', $true, $true)
