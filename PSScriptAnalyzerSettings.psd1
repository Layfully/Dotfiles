# PSScriptAnalyzer rules for every .ps1 in the repo, used by .github/workflows/lint.yml.
# The VS Code PowerShell extension picks this file up from the workspace root as well.
@{
    Severity     = @('Error', 'Warning')
    ExcludeRules = @(
        # Setup and hook scripts print coloured progress for a person watching the run
        'PSAvoidUsingWriteHost'
        # The profile shares state with lazily loaded code through $global: variables
        'PSAvoidGlobalVars'
        # Key handler and completer script blocks must declare the parameters PSReadLine passes in
        'PSReviewUnusedParameter'
        # The Claude Code installer is only published as a script to download and run
        'PSAvoidUsingInvokeExpression'
        # pwsh 7 reads BOM-less files as UTF-8, so this only matters for the GitHooks scripts, which
        # Windows PowerShell 5.1 runs; the lint workflow checks those with this rule separately
        'PSUseBOMForUnicodeEncodedFile'
    )
}
