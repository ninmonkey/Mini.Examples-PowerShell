#Requires -Version 7.0
using namespace System.Collections.Generic
# most of the code does not use much of 7,
# most is easily factored out for 5.1

function _fmt_ShortTypeName {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject
    )
    begin {
        $Str = @{
            Null  = "`u{2400}"
            Empty = 'Str::Empty'
        }
    }

    process {
        if ($Null -eq $InputObject) {
            return $Str.Null
        }
        if ($InputObject -is [String] -and $InputObject -eq [string]::Empty) {
            return $Str.Empty
        }
        # $maybeType =
        # if($InputObject -is [String] -and ())
        if ($InputObject -is [string] -and $InputObject -as 'type') {
            $tinfo = $InputObject -as 'type'
        } elseif ($InputObject -is 'type') {
            $tInfo = $InputObject
        } else {
            $tinfo = ($InputObject)?.GetType()
        }
        Write-Debug $tinfo.GetType()
        label 'test' $tinfo.GetType()
        # $info.FullName does not work well with generics

        $tinfo = $InputObject.name
    }
}

function Get-ObjectTypeInfo {
    <#
    .synopsis
        Tests GetType(), clean and filter output
    .notes
        future:
            - improve output of Generic types. They return assembly versions, like spam
            - shows every type, even if they are identical
            - add script property on [type] to call this
            - allow more namespaces
            -
    #>
    [Alias('TypeInfo', 'WhatType')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$InputObject
    )
    begin {
        $regexPrefix = '^' + [regex]::Escape('System.')
    }
    process {

        # try this logpoint: it includes colors
        #   $($InputObject | ShortType | Label 'WhatType')
        $mainType = $InputObject.GetType().FullName -replace $regexPrefix, ''
        | Join-String -op '[' -os ']'

        $chil

        '{0} of {1}' -f @(
            $mainType
            'wip children'
        )
    }
}


H1 'start'
$Files = Get-ChildItem c:\ | Select-Object -First 1
whatType $Files # returns 1 folder [IO.DirectoryInfo]

$files = @(Get-ChildItem c:\ | Select-Object -First 1)
whatType $Files # returns array of 1 folder

$files = @()
whatType $Files

[list[int]]$lInt = [list[int]]::new( [int[]]@(0..5 ) )
WhatType $Lint

Hr
$dict = [dictionary[[string], [int]]]::new()
$dict.Add('a', 30)
# $Dict.GetType().GenericTypeArguments
$dict.GetType().GenericTypeArguments
| Join-String -sep ', ' { $_ | shortType } -op '<Dict[ ' -os ' ]>'
| UL

$dict.GetType().name


Join-String @joinStringSplat
Hr
H1 'fin'


$dict = [dictionary[[string], [int]]]::new()
$dict.Add('a', 30)
# $Dict.GetType().GenericTypeArguments
H1 'generic: No Color'
$joinStringSplat = @{
    Separator    = ', '
    OutputPrefix = '[Dict['
    OutputSuffix = ']]'
    Property     = { $_ }
}

$dict.GetType().GenericTypeArguments
| Join-String @joinStringSplat

#| UL
$dict.GetType().name

H1 'generic: Color'
$joinStringSplat = @{
    Separator    = ', '
    OutputPrefix = '[Dict['
    OutputSuffix = ']]'
    Property     = { $_ }
}

function _renderTest {
    H1 'render test' -fg magenta
    $BaseType = $Dict.GetType().Name
    $join_genArgs = @{
        Separator    = '], ['
        # Separator    = ', '
        # OutputPrefix = '[Dict['
        OutputPrefix = '['
        OutputSuffix = ']'
        Property     = { $_ }
    }

    $GenericArgs = $dict.GetType().GenericTypeArguments
    | Join-String @join_genArgs

    @(
        "[${BaseType}["
        "${GenericArgs}"
        ']]'
    ) -join ''
    Hr
    $BaseType = $Dict.GetType().Name -replace '`\d+$', ''
    @(
        "${BaseType}"
        "<${GenericArgs}>"
        ''
    ) -join ''
    Hr
    $BaseType = $Dict.GetType().Name -replace '`\d+$', ''
    @(
        '['
        "${BaseType}"
        "<${GenericArgs}>"
        ''
        ']'
    ) -join ''
    Hr -fg 'magenta'
}
_renderTest
H1 'next'

$dict.GetType().GenericTypeArguments
| Join-String @joinStringSplat

#| UL
$dict.GetType().name

<#
$JoinCsv = @{ Separator = ', ' }


[double]$alwaysDouble = '213.5'
[int64]$AlwaysInt = '213.5'

# this is a coercion. weakInt is not strongly typed
$WeakInt = [int]'213.45'

[string]$AlwaysString = 1e9

$AlwaysDouble, $AlwaysInt, $AlwaysString
| WhatType
| Join-String @joinCsv

# See more: 'gcm Utility\Get-ElementName
$AlwaysInt = 'zabc' # SHould Error because 'No valid conversion path for "Z"'
$WeakList = 'abc'
$weakInt = 'abc'
$AlwaysInt, $WeakList, $WeakInt
| WhatType

# $numDouble | TypeInfo

# Get-Item . | TypeInfo
# [Double]
# [IO.DirectoryInfo]
#>