<#
about:
    stand alone example that compares formatting with different PSScriptAnalyzer rules


    Invoke-Formatter
#>

$script = @'
Get-ChildItem |
Where-Object Name -Like 'foo'

Get-ChildItem |
ForEach-Object Name
'@

$settings = @{
    IncludeRules = @('PSUseConsistentIndentation')
    Rules        = @{
        PSUseConsistentIndentation = @{
            Enable              = $true
            # Kind                = 'space'
            PipelineIndentation = 'None' # broke
            # IndentationSize     = 4
        }
    }
}
"

To reproduce: PipelineIndentation = None`n"
PSScriptAnalyzer\Invoke-Formatter -ScriptDefinition $script -Settings $settings

foreach ($mode in ('IncreaseIndentationAfterEveryPipeline', 'IncreaseIndentationForFirstPipeline', 'IncreaseIndentationAfterEveryPipeline', 'NoIndentation', 'None', '')) {
    "`n`n### Mode: '$Mode' `n`n"
    $settings.Rules.PSUseConsistentIndentation.PipelineIndentation = $Mode
    PSScriptAnalyzer\Invoke-Formatter -ScriptDefinition $script -Settings $settings
}