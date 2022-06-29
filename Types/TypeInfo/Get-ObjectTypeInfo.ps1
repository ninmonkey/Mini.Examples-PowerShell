#Requires -Version 7.0
using namespace System.Collections.Generic
# most of the code does not use much of 7,
# most is easily factored out for 5.1

function ShortTypeName {
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
    .example

        Pwsh🐒>
            $intList = [list[int]]::new( [int[]]@(3, 45, 99))

            ,$intList | Get-ObjectTypeInfo
            Get-ObjectTypeInfo $intList

            ,(gi . ) | Get-ObjectTypeInfo
            ,(gci . ) | Get-ObjectTypeInfo

        Output:

            [Collections.Generic.List`1] of [Int32]
            [Collections.Generic.List`1] of [Int32]
            [IO.DirectoryInfo]
            [Object[]] of [IO.FileInfo]


    #>
    [Alias('TypeInfo')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$InputObject,

        # how many elements?
        [switch]$ShowCount
    )
    begin {
        $regexPrefix = '^' + [regex]::Escape('System.')
    }
    process {

        # try this logpoint: it includes colors
        #   $($InputObject | ShortType | Label 'WhatType')
        $mainType = $InputObject.GetType().FullName -replace $regexPrefix, ''


        $mainType = @(
            $main_tinfo = $InputObject.GetType()
            $main_tinfo.Namespace, '.', $main_tinfo.name -join '' -replace $regexPrefix, ''
        )
        | Join-String -op '[' -os ']'

        # $hasChild = $InputObject.count -gt 1
        # if ($HasChild) {
        # Get-ObjectTypeInfo @($InputObject)[0]
        # $renderChild = WhatType @($InputObject)[0]
        # if ($inputObject.count -gt 1 ) {
        #     $renderChild = shortTypeName ( $InputObject | Select-Object -First 1)
        # } else {
        #     $renderChild = 'none'
        # }
        # }

        $Suffix = ''
        $StrCount = if ($ShowCount) {
            "$($InputObject.Count) "
        } else {
            ''
        }
        if ($InputObject.count -gt 1) {
            $Count = $InputObject.count
            $renderChild = shortTypeName ( $InputObject | Select-Object -First 1)
            $Suffix = " of ${strCount}${renderChild}"
        }
        $mainType, $Suffix -join ''
    }
}

if ($False) {
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
}