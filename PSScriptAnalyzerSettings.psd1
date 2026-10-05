# PSScriptAnalyzer rules for every .ps1 in the repo, used by .github/workflows/lint.yml.
# The VS Code PowerShell extension picks this file up from the workspace root as well.
@{
    Severity     = @('Error', 'Warning')
    ExcludeRules = @(
        # Setup and hook scripts print coloured progress for a person watching the run
        'PSAvoidUsingWriteHost'
        # The scripts run under pwsh 7, which reads BOM-less files as UTF-8
        'PSUseBOMForUnicodeEncodedFile'
    )
}
