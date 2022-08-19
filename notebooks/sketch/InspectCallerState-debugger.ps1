Import-Module Ninmonkey.Console -Force
$MyInvocation | io

return

$DocString = @'

- [auto var $MyInvocation](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#myinvocation)
- [auto var $PSBoundParameters](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#psboundparameters)
- [auto var $PSCmdlet](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7#pscmdlet)
- [\[PSCmdlet\] attribute](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7)

docs:
    Get-Hep about_Functions_*

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7
[about_Functions_Advanced](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_Advanced)
[about_Functions_Advanced_Methods](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_Advanced_Methods)
[about_Functions_Advanced_Parameters](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_Advanced_Parameters)
[about_Functions_Argument_Completion](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_Argument_Completion)

MyInvocationInfo
    - is a [System.Management.Automation.InvocationInfo]

iter0
    TargetObject -is [PSScriptCmdlet]
    MyInvocation -is [InvocationInfo]
    PSCmdlet -is [PSScriptCmdlet]

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

        $strNA = '[n/a]'
        $metaPSCmdlet = [ordered]@{
            Partition         = 'PSCmdlet'
            Self              = $PSCmdlet
            BoundParameters   = $PSCmdlet.MyInvocation.BoundParameters
            UnBoundParameters = $PSCmdlet.MyInvocation.UnboundArguments
            PSBoundParameters = $strNA # maybe with state
            SessionState      = $PSCmdlet.SessionState
        }
        # $MyInvocationInfo = 10
        # $MyInvocationInfo
        $MyInvocation
        $metaMyInvoke = [ordered]@{
            Partition         = 'MyInvocationInfo'
            Self              = $MyInvocation
            BoundParameters   = $MyInvocation.BoundParameters
            UnBoundParameters = $MyInvocation.UnboundArguments

            PSBoundParameters = $strNA # or $PSCmdlet.MyInvocation.UnboundArguments


            # BoundParameters   = $MyInvocation.BoundParameters
            # UnBoundParameters = $.MyInvocation.UnboundArguments
            # PSBoundParameters = $PSBoundParameters
        }
        $metaTarget = [ordered]@{
            Partition                      = 'Target'
            Self                           = $TargetObject
            BoundParameters                = $TargetObject.BoundParameters
            UnBoundParameters              = $TargetObject.BoundParameters
            MyInvocation_BoundParameters   = $TargetObject.MyInvocation.BoundParameters
            MyInvocation_UnBoundParameters = $TargetObject.MyInvocation.UnboundArguments
            PSBoundParameters              = $strNA

        }
        $meta = @{
            PSBoundParameters = $PSBoundParameters

            PSCmdlet          = [pscustomobject]$metaPSCmdlet
            MyInvocationInfo  = [pscustomobject]$metaMyInvoke
            Target            = [pscustomobject]$metaTarget
        }

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