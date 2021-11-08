#Requires -Version 7

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
function New-MarkdownHeader {
    <#
    .synopsis
        minimal wrapper to export code wrappped in markdown 
    #>
    [CmdletBinding()]
    param(
        # raw text
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$InputText,        

        # code fence language
        [Parameter()]
        [uint]$Depth = 2
        
    )
    begin {
        $Template = '{0} {1}'
    }
    end {        
        $Template -f @(
            ('#' * $Depth)
            $InputText
        )
    }
}
function New-MarkdownCodeFence {
    <#
    .synopsis
        minimal wrapper to export code wrappped in markdown 
    #>
    [CmdletBinding()]
    param(
        # raw text
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$InputText,

        # code fence language
        [Parameter()]
        [string]$Language
        
    )
    begin {
        $Template = @'
```{0}
{1}
```
'@
    }
    end {
        $codeChunk = $InputText -join "`n"
        $Template -f @(
            $Language ?? ''
            $codeChunk
        )
    }
}
function Write-Newline {
    param([int]$Count = 1)
    "`n" * $count
}

$AlwaysOpen = $true
$AlwaysOpen = $false

"To reproduce: PipelineIndentation = None`n"
PSScriptAnalyzer\Invoke-Formatter -ScriptDefinition $script -Settings $settings

[string[]]$mdDoc = ''
foreach ($mode in ('IncreaseIndentationAfterEveryPipeline', 'IncreaseIndentationForFirstPipeline', 'IncreaseIndentationAfterEveryPipeline', 'NoIndentation', 'None', '')) {
    "`n`n### Mode: '$Mode' `n`n"
    $settings.Rules.PSUseConsistentIndentation.PipelineIndentation = $Mode



    
    # $mdDoc += New-MarkdownHeader -InputText "Mode: '$Mode'"
    $mdDoc += Write-Newline 2
    
    $result = $settings | ConvertTo-Json
    $result
    $mdDoc += New-MarkdownCodeFence $result -Language json

    $result = PSScriptAnalyzer\Invoke-Formatter -ScriptDefinition $script -Settings $settings
    $result
    $mdDoc += New-MarkdownCodeFence $result -Language ps1
    $mdDoc += Write-Newline 2

}

Set-Content -Path 'temp:\md.md' -Value $mdDoc
if ($AlwaysOpen) {
    code-venv -p (Get-Item temp:\md.md)
}