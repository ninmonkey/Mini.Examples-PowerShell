#Requires -Version 7

# for: -> Types -> Get-TypeInfo.ps1

function Get-ObjectTypeInfo {
    <#
    .synopsis
        get type info, unless it's already a type
    .example
        $x = 10
        'int', [uint], $x, $x.GetType() | Get-ObjectTypeInfo
    .outputs
        [string]
    #>
    [cmdletbinding()]
    param(
        # don't error on nulls, return type's abbreviated names
        [AllowNull()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject
    )
    process {
        if ($null -eq $InputObject) {
            return
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
        # $tinfo.FullName #| Write-Debug
        $tinfo.Name
    }
}

& {
    $strTypeName = @{
        Separator = ', '
        Property  = { "[$_]" }
    }
    $strHeader = @{
        OutputPrefix = "`n## "
        OutputSuffix = " ##`n"
    }

    $results = 'int', [uint], $x, $x.GetType()
    | Get-ObjectTypeInfo -Debug
    | Join-String @strTypeName

    'Validate' | Join-String @strHeader
    $results | Should -Be '[Int32], [UInt32], [Int32], [Int32]'

    "It's good"

    'example' | Join-String @strHeader
    $results

    'examples' | Join-String @strHeader

    $samples = @(
        [double].GetType()
        4
        $Null
        'int'
        [double]
        , $Null
        @(Get-ChildItem env:) | Select-Object -First 1
        @($null)

    )

    $samples | Get-ObjectTypeInfo

    # $files = (Get-ChildItem . -File) | First 1
    @(
        (Get-Process )[0] | Get-ObjectTypeInfo
        (Get-Process | First 1 ), (Get-ChildItem . ), @($null), $null, [int]
    ) | Get-ObjectTypeInfo

}
