#Requires -Version 7.0
using namespace System.Collections.Generic
# most of the code does not use much of 7,
# most is easily factored out for 5.1


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
        $InputObject.GetType().FullName -replace $regexPrefix, ''
        | Join-String -op '[' -os ']'
    }
}

$JoinCsv = @{ Separator = ', ' }


[double]$alwaysDouble = '213.5'
[int64]$AlwaysInt = '213.5'

# this is a coercion. weakInt is not strongly typed
$WeakInt = [int]'213.45'

[string]$AlwaysString = 1e9


# generics
$weakList = [List[object]]::new( @(0, 3, 6, 32))
[List[object]]$AlwaysList = [List[object]]::new()

. {
    $query = $script:query
    $x = 3
}
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