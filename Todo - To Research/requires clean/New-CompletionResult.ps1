using namespace System.Management.Automation;
function New-CompletionResult {
    <#
    .synopsis
        Create a [System.Management.Automation.CompletionResult]
    .example
        PS> New-CompletionResult '--info' 'info' ParameterName 'List installed .net runtimes'

        CompletionText : --info
        ListItemText   : info
        ResultType     : ParameterName
        ToolTip        : List installed .net runtime
    #>
    param(
        [Parameter(
            Mandatory, Position = 0,
            HelpMessage = "Completion Result returned")]
        [string]$CompletionText,

        [Parameter(
            Mandatory, Position = 1,
            HelpMessage = 'Text displayed in the popup, usually equal to -CompletionText without a "--" prefix. ')]
        [string]$ListItemText,

        [Parameter(
            Mandatory, Position = 2,
            HelpMessage = "enum: [System.Management.Automation.CompletionResultType]
            note: it might need to be string for more compatability ?")]
        [CompletionResultType]$ResultType,

        [Parameter(
            Mandatory, Position = 3, HelpMessage = 'Verbose description shown when a single command is selected')]
        [string]$Tooltip
    )

    process {
        # Write-Debug "completion test: $($CompletionText.GetType())"

        # "New [CompletionResult]: $CompletionText, $ListItemText, $ResultType, $Tooltip" | Write-Debug


        $Result = [CompletionResult]::new( $CompletionText, $ListItemText, $ResultType, $Tooltip)
        $ResultType | Format-Table | Out-String -Width 99999 | Write-Debug

        $Result
    }
}

# New-CompletionResult  -Debug
# hr
# [CompletionResult]::new( '/all', '/All', [CompletionResultType]::ParameterName, 'all' )