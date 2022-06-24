function DoSomething {
    <#
    ref:
        seemingly science: https://discord.com/channels/180528040881815552/447476117629304853/964691752126668890

        https://discord.com/channels/180528040881815552/447476117629304853/964688000334307408
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [psobject] $InputObject
    )
    begin {
        $pipe = { Export-Excel @PSBoundParameters }.GetSteppablePipeline()
        $pipe.Begin($MyInvocation.ExpectingInput)
    }
    process {
        $pipe.Process($PSItem)
    }



    end {
        $pipe.End()
    }
}
