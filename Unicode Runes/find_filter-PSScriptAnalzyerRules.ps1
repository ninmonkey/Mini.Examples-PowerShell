function Find-PsaRule {
    <#
    .synopsis
        tiny wrapper for searching
    .example
        PS> Find-PsaRule            # show prop types
        | Select-Object -First 1 *

            RuleName         : PSAlignAssignmentStatement
            CommonName       : Align assignment statement
            Description      : Line up assignment statements such that the assignment operator are aligned.
            SourceType       : Builtin
            SourceName       : PS
            Severity         : Warning
            ImplementingType : Microsoft.Windows.PowerShell.ScriptAnalyzer.BuiltinRules.AlignAssignmentStatement
    #>
    param(
        # highlight? todo: abstract this logic, filter props by a regex for ( -match 'str1|str2'  ) used in a few places.
        [Parameter()]
        [string[]]$Name,

        # show details, then quit
        [Parameter()]
        [switch]$Detail,

        # out grid/html
        [Parameter()]
        [switch]$OutGridView,

        # out grid/html
        [Parameter()]
        [switch]$NotHtmlOut
    )

    $rules = PSScriptAnalyzer\Get-ScriptAnalyzerRule

    if ($Detail) {

        Write-ConsoleHeader 'SourceNames' -af 0
        PSScriptAnalyzer\Get-ScriptAnalyzerRule
        | Group-Object SourceName -NoElement | Sort-Object Count
    }
    # | Out-Default | Write-Information
    Label 'htmlout' $hasOutHtml
    Label 'not' $nothatm
    if ($OutGridView) {
        $hasOutHtml = Get-Command 'Out-GridHtml' -ea ignore
        if ($NotHtmlOut -or (!$hasOutHtml) ) {
            'sdf'
        }
        else {
        }

        # if (($NotHtmlOut) -and $hasOutHtml) {
        #     $rules | Out-GridHtml #-Verbose
        # }
        # else {
        #     # $rules | Out-GridView
        #     # $rules | Select-Object * | Out-GridView
        #     $f = 3

        # }

        # if ($OutGridView) {
        #     if ( -and (Get-Command -ea ignore 'Out-GridHtml')) {
        #     }
        #     else {
        #     }
        # }

        return
    }


    $rules
}

# | Group-Object SourceName -NoElement | Sort-Object Count
# | Select-Object -First 1 *

# Find-PsaRule -Detail
# Find-PsaRule -OutGridView -NotHtmlOut
# Find-PsaRule -OutGridView