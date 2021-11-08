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
$templateFence = @'

```ps1
{0}
```

'@
"

To reproduce: PipelineIndentation = None`n"

[string]$doc = ''

PSScriptAnalyzer\Invoke-Formatter -ScriptDefinition $script -Settings $settings
| Out-Null

$doc += @'
## Initial script

```ps1
{0}
```
'@ -f @(
    $script
)

foreach ($mode in ('IncreaseIndentationAfterEveryPipeline', 'IncreaseIndentationForFirstPipeline', 'IncreaseIndentationAfterEveryPipeline', 'NoIndentation', 'None', '')) {
    $line = "`n`n**Mode**: ``$Mode```n`n"    
    $settings.Rules.PSUseConsistentIndentation.PipelineIndentation = $Mode
    $result = PSScriptAnalyzer\Invoke-Formatter -ScriptDefinition $script -Settings $settings
    
    $doc += $line    
    $doc += $templateFence -f @(
        $result
    )

}
hr

$doc | sc -path 'temp:\doc.md'
Hr
Get-Content (Get-Item 'temp:\doc.md')