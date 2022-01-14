

# for: -> Types -> Get-TypeInfo-Part2.ps1
function Get-TypeInfo {
    [cmdletbinding()]
    param(
        [AllowNull()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        [switch]$AsChild
    )
    process {
        if ($null -eq $InputObject) {
            '[␀]' ; return
        }

        if ($InputObject -is 'type') {
            $tinfo = $InputObject
        } elseif ($InputObject -is 'string' ) {
            $maybeType = $InputObject -as 'type'
            if ($maybeType) {
                $tinfo = $maybeType
            }
        } else {
            $tinfo = $InputObject.GetType()
        }

        if ($AsChild) {
            $tinfo.FullName
            return
        }
        $tinfo.FullName | Write-Color 'red'
        if ($tinfo.count -gt 0) {
            $child = $InputObject[0] #?.GetType()
            $childStr = $child | Get-TypeInfo -AsChild | Join-String -op '[' -os ']'
            #@($child)?.[0] | Get-TypeInfo -AsChild
            "  child: $child" | Write-Color 'blue'
        }
    }
}




hr 2
([double].GetType()), 4, $Null, 'int', [double], (Get-ChildItem env:) | Get-TypeInfo2

return

hr 2


#$files = (Get-ChildItem . -File) | First 1

(Get-Process )[0] | Get-TypeInfo
(Get-Process | First 1 ), (Get-ChildItem . ), @($null), $null, [int] | Get-TypeInfo
