$file1 = Get-ChildItem ~ | Select-Object -First 1
$file2 = Get-ChildItem ~ | Select-Object -First 1 -Skip 10
function Compare-ObjectProperties {
    <#
    .synopsis
        Compares properties of two objects
    #>    
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
            Name  = $Prop
            Left  = $Left.$Prop
            Right = $Right.$Prop
            Equal = $Left.$Prop -eq $Right.$Prop
        }
    }
    $results | Sort-Object Equal, Name
}

h1 'all properties'
$results = Compare-ObjectProperties $file1 $file2
$results | Format-Table

hr
h1 'only differences'
$results | Sort-Object Equal
| Where-Object { ! $_.Equal }
| Format-Table Name, Left, Right -AutoSize



hr 
h1 'all properties | groupby'
$results | Sort-Object Equal, Name
| Format-Table Name, Left, Right -AutoSize -GroupBy Equal


$cult1 = Get-Culture
$cult2 = Get-Culture -Name 'de'