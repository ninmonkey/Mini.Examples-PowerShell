$Ext = '*.pbix'
$parents = @(
    Join-Path $env:USERPROFILE '\Documents\2021\'
    Join-Path $env:USERPROFILE '\Documents\2020\'
    # './2020', './2021'
)

$ls_ByExt = @{
    Path    = $parents
    Recurse = $true
    Filter  = $Ext
}

$lsType ??= Get-ChildItem @ls_ByExt
$sort_newestWrite = @{
    Descending = $true
    Top        = 5
    Property   = 'LastWriteTime'
}

$newestWrite = $lsType | Sort-Object @sort_newestWrite
$newestWrite
h1 'latest: pbix'
$newestWrite | Join-String -Separator "`n" -SingleQuote FullName
h1 'relativepath: pbix'
$newestWrite | Join-String -Separator "`n" -SingleQuote { $_ | Format-RelativePath }

h1 'or Everything.exe'
$query = 'es:dm:{0} ext:{1}' -f @(
    'today'
    'pbix'
)
# Start-Process 'es:dm:today ext:pbix'
Start-Process $query

$parents | Join-String -Separator ', ' -SingleQuote
| Label 'parents'
