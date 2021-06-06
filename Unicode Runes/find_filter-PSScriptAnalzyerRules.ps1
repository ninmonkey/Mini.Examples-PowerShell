#Requires -Module PSScriptAnalyzer

function Find-PsaRule {
    <#
    .synopsis
        tiny wrapper for searching
    .example
        PS> Find-PsaRule -Mode HtmlGrid
        PS> Find-PsaRule -Mode PassThru
        PS> Find-PsaRule -Mode OutGrid

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
        [Parameter(Position = 0)]
        [string[]]$Pattern,

        # show details, then quit. does nothing really.
        # [Parameter()]
        # [switch]$Detail,

        # output mode
        [Parameter(Position = 1)]
        [Alias('Mode')]
        [ValidateSet('PassThru', 'OutGrid', 'HtmlGrid')]
        [string]$OutFormat = 'PassThru',

        # show details, then quit. does nothing really.
        [Parameter()]
        [alias('SortOrder')]
        [string[]]$HeaderOrder = ('SourceName', 'RuleName', 'Severity', 'Description')
    )


    $rules = PSScriptAnalyzer\Get-ScriptAnalyzerRule
    | Sort-Object -Property SourceName, RuleName, Severity

    if ( $pattern ) {
        'filter'
        # $rules = $rules | %{
        return;

    }

    # if ($Detail) {
    #     Write-ConsoleHeader 'SourceNames' -af 0
    #     $rules
    #     | Group-Object SourceName -NoElement | Sort-Object Count

    #     return
    # }
    if ($OutFormat -eq 'PassThru') {
        $rules
        return
    }
    $rules = $rules
    | Select-Object -Property $HeaderOrder

    switch ($OutFormat) {
        'OutGrid' {
            $rules | Out-GridView -PassThru
            break
        }
        'HtmlGrid' {
            $rules | Out-GridHtml -PassThru
            break
        }
        default {
            # ShouldNever
        }
    }
}

