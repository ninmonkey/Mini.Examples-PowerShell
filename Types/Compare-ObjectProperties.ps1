#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Compare-ObjectProperty'
    )
    $experimentToExport.alias += @(
        'DiffProps'
    )
}

function Compare-ObjectProperty {
    <#
    .synopsis
        Compares properties of two objects
    .notes
    .link
        Microsoft.PowerShell.Utility\Compare-Object
    #>
    [Alias('DiffProps')]
    [cmdletbinding()]
    param(
        # first
        [Parameter(Mandatory, Position = 0)]
        [object]$Left,

        # second
        [Parameter(Mandatory, Position = 1)]
        [object]$Right
    )

    # or you can use
    # $left.psobject.properties | ForEach-Object { ... }

    $PropertyNames = $Left | Get-Member -MemberType Properties | ForEach-Object Name
    $results = foreach ($Prop in $PropertyNames) {
        [pscustomobject]@{
            PSTypeName = 'nin.PropertyComparison'
            Name       = $Prop
            Left       = $Left.$Prop
            Right      = $Right.$Prop
            Equal      = $Left.$Prop -eq $Right.$Prop
            EqualCast  = [bool]($Left.$Prop -eq $Right.$Prop)
            ValueAbbr  = if ($Left.$Prop -eq $Right.$Prop) {
                $Left
            } else {
                '!='
            }
        }
    }
    $results | Sort-Object Equal, Name
}

# if equal,then darken out.

if (! $experimentToExport) {
    # ...
    $file1 = Get-ChildItem ~ | Select-Object -First 1
    $file2 = Get-ChildItem ~ | Select-Object -First 1 -Skip 10

    $f = Get-Item .
    $gm1 = ($f ) | Get-Member -MemberType Properties
    $gm2 = ($f ) | Get-Member -MemberType Properties -Force
    $gm3 = $f | iterProp | ForEach-Object Name

    H1 'all properties'
    $results = Compare-ObjectProperty $file1 $file2
    $results | Format-Table

    hr
    H1 'only differences'
    $results | Sort-Object Equal
    | Where-Object { ! $_.Equal }
    | Format-Table Name, Left, Right -AutoSize



    hr
    H1 'all properties | groupby'
    $results | Sort-Object Equal, Name
    | Format-Table Name, Left, Right -AutoSize -GroupBy Equal

    $results | First 8 | Format-Table Equal, Name, Left, Right
    $results | Where-Object { ! $_.Equal } | First 8 | Format-Table Equal, Name, ValueAbbr


    $cult1 = Get-Culture
    $cult2 = Get-Culture -Name 'de'
    $cultRes = Compare-ObjectProperty $cult1 $cult2

    $cultRes
    # | Sort-Object Equal
    | Where-Object { ! $_.Equal }
    | Format-Table Name, Left, Right -AutoSize

    H1 'test'
    $f = Get-Item .
    $gm1 = ($f ) | Get-Member -MemberType Properties
    $gm2 = ($f ) | Get-Member -MemberType Properties -Force
    $gm3 = $f | iterProp | ForEach-Object Name

    $basicCompare = Compare-Object $cult1 $cult2$
    $basicCompare

    $gm1, $gm2, $gm3 | len
}