#Requires -Version 7

function _convertException_ToLocation {
    <#
    .synopsis
        Tested on error records
    .notes
        see: https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.InvocationInfo?view=powershellsdk-7.0.0
    .outputs
        [nin.VSCodeFilepath]
    .link
        Dev.Nin\ConvertFrom-ScriptExtent
    .link
        System.Management.Automation.InvocationInfo
    .link
        System.Management.Automation.CmdletInvocationException
    .link
        System.Management.Automation.ErrorRecord

    #>
    [cmdletbinding()]
    param(
        # ErrorRecord (or info?)
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    process {
        $InputObject.GetType() | Join-String -op 'type: ' | Write-debug

        if ($InputObject -is 'System.Management.Automation.CmdletInvocationException') {            
            $input_record = $InputObject.ErrorRecord
        }
        else {
            $input_record = $InputObject
        }
        if ($Null -eq $input_record) {
            Write-Error 'Failed to find ErrorRecord'
            return
        }

        $iinfo = $input_record.InvocationInfo
        
        # $iinfo.DisplayScriptPosition # [IScriptExtent]        
        $maybePath = $iinfo.ScriptName | Get-Item -ea ignore
        $maybePath ??= $iinfo.ScriptName

        $meta = [ordered]@{
            PSTypeName      = 'nin.VSCodeFilepath'
            ColumnNumber    = $iinfo.OffsetInLine
            HasLocation     = $True 
            LineNumber      = $iinfo.ScriptLineNumber
            ScriptExtent =    $iinfo.DisplayScriptPosition
            Path            = $iinfo.ScriptName
            PositionMessage = $iinfo.PositionMessage
            PSPath          = $maybePath
        }
        [pscustomobject]$meta
    }
}

WhatIs . # some thing that throws
$Error[0] | _convertException_ToLocation

<# output:


🐒> $Error[0] | _convertException_ToLocation

ColumnNumber    : 9
HasLocation     : True
LineNumber      : 39
ScriptExtent    :
Path            : C:\Users\nin\Dev.Nin
                  public_experiment\WhatIs.ps1
PositionMessage : At C:\Users\nin\Dev.
                  in\public_experiment\WhatIs.ps1:39 char:9
                  +         1 / 0
                  +         ~~~~~
PSPath          : C:\Users\nin\Dev.Nin
                  public_experiment\WhatIs.ps1
#>