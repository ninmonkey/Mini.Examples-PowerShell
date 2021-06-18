using namespace System.Management.Automation
function wipNew-CompletionResult {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$CompletionText,

        [Parameter(Mandatory, Position = 1)]
        [string]$ListItemText,

        [Parameter(Mandatory, Position = 2)]
        [CompletionResultType]$ResultType,

        [Parameter(Mandatory, Position = 3)]
        [string]$Tooltip
    )


}




$sbTraceTest = {
    wipNew-CompletionResult '/showclassid6', '/ShowClassId6', [CompletionResultType]::ParameterName, 'display'
}

# code 'temp:\codeout'

# h1 'start'
# Format-TraceCommand -Expression $sbTraceTest