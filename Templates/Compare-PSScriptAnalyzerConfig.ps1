<#
about:
    stand alone example that compares formatting with different PSScriptAnalyzer rules


    Invoke-Formatter
#>
$meta = @{
    PSScriptAnalyzer                    = Get-Module PSScriptAnalyzer | ForEach-Object Version | ForEach-Object tostring
    Powershell                          = $PSVersionTable.PSVersion.ToString()
    PowerShellEditorServices            = '0.2.0'
    EditorServicesCommandSuite          = '1.0.0'
    'PowerShellEditorServices.Commands' = '0.2.0'
}

$versionTableMD = @(
    'Module', 'Version' | str Table
    ' - ', ' - ' | str Table
    $meta.GetEnumerator() | ForEach-Object {
        $_.key, $_.Value | str Table
    }
) -join "`n"

$script = @'
Get-ChildItem |
Where-Object Name -Like 'foo'

Get-ChildItem |
ForEach-Object Name
'@
$script = @'
Write-Verbose "$functionName User did not specify Region, using default values $($Region -join ', ')."
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
## Environment

{0}

## Initial script

```ps1
{1}
```
'@ -f @(
    $versionTableMD
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
$dest = (Join-Path $PSScriptRoot 'doc.md')

$doc | sc -path $dest
# $doc | sc -path 'temp:\doc.md'
Hr
Get-Content $dest
# Get-Content (Get-Item 'temp:\doc.md')