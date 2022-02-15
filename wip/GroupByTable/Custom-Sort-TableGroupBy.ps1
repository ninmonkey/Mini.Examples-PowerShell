function exampleGroupByExtension {
    param(
        #
        [Parameter(Mandatory, Position = 0)]
        [string]$Path,

        [Parameter()]
        [int]$Depth
    )
    end {
        $splatLs = @{
            Path = $Path ?? '.'
        }
        if (! $Depth) {
            $splatLs['Recurse'] = $true
        }
        Get-ChildItem $splatLs


    }

}

return

$Path ??= '.'
$sortbY = 'Extension'
$SbGroupByExt = @{
    Name       = 'When'
    Expression = {
        #$when = $_.LastWriteTime
        #$when.Year, $when.Month, $When.Day
        $_.Extension
    }
}

$InputObject = Get-ChildItem $Path -Depth 2
#        $InputObject | Sort-Object -p $sortbY
$InputObject | Sort-Object -p $SbGroupByExt.Expression
| Format-Table -GroupBy $SBTableGroupExt -RepeatHeader


$Path ??= '.'
$sortbY = 'Extension'
$SbGroupByExt = @{
    Name       = 'When'
    Expression = {
        #$when = $_.LastWriteTime
        #$when.Year, $when.Month, $When.Day
        $_.Extension
    }
}

$InputObject = Get-ChildItem $Path -Depth 2
#        $InputObject | Sort-Object -p $sortbY
$InputObject | Sort-Object -p $SbGroupByExt.Expression
| Format-Table -GroupBy $SBTableGroupExt -RepeatHeader
