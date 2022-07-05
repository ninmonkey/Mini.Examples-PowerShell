$DocString = @'

-  [automatic MyInvocation](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#myinvocation)

MyInvocationInfo
    - is a [System.Management.Automation.InvocationInfo]
'@
function Parent {
    <#
    .synopsis
    something to inspect
    #>
    [Alias('Other')]
    [CmdletBinding()]
    param(
        [string]$Label,
        [object[]]$Path,
        [switch]$EnableA,
        [switch]$DisallowB,
        [hashtable]$Options
    )
    begin {
        $Config = $Options

        CollectInfo -Label 'Begin' -Target $PSCmdlet
    }
    process {
    }
    end {
    }
}

function CollectInfo {
    <#
    .synopsis
        try to get caller, or at least target's info
    #>
    [CmdletBinding()]
    param(
        [string]$Label,
        [object]$TargetObject
    )
    begin {
        $metaPSCmdlet = [ordered]@{
            Partition         = 'PSCmdlet'
            BoundParameters   = $PSCmdlet.MyInvocation.BoundParameters
            UnBoundParameters = $PSCmdlet.MyInvocation.UnboundArguments
            PSBoundParameters = 'n/a'
        }
        $metaMyInvoke = [ordered]@{
            Partition         = 'MyInvocationInfo'
            BoundParameters   = $PSCmdlet.MyInvocation.BoundParameters
            UnBoundParameters = $PSCmdlet.MyInvocation.UnboundArguments
            PSBoundParameters = $PSBoundParameters
        }
        $metaTarget = [ordered]@{
            Partition                      = 'Target'
            BoundParameters                = $TargetObject.BoundParameters
            UnBoundParameters              = $TargetObject.BoundParameters
            MyInvocation_BoundParameters   = $TargetObject.MyInvocation.BoundParameters
            MyInvocation_UnBoundParameters = $TargetObject.MyInvocation.UnboundArguments
            PSBoundParameters              = 'n/a'

        }
        $meta = @{
            PSCmdlet         = [pscustomobject]$metaPSCmdlet
            MyInvocationInfo = [pscustomobject]$metaMyInvoke
            Target           = [pscustomobject]$metaTarget
        }
        return
    }
    process {
    }
    end {
        $meta = [ordered]@{
        }
        'sdfdsf'
        [pscustomobject]$meta
    }
}

Parent -Label 'FirstParent' -Path 'lakeville', 'west' -EnableA -infa 'Continue'
Other -Label 'OtherParent' -Path 'elsewhere' -DisallowB -infa 'continue'
CollectInfo -Label 'Global State?' -TargetObject $null