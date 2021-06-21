h1 'base'
Get-ChildItem . | ForEach-Object {
    Join-String -InputObject $_  -Separator ', ' {
        '{0} <{1:n2}>' -f @($_.Name, $_.Length)
    }
}
| Join-String -sep "`n" { $_.PadLeft(30, ' ') }


h1 'Iter2'
$files = Get-ChildItem -Path $Env:USERPROFILE
$name_maxWidth = $files.Name.Length | Measure-Object -Maximum | ForEach-Object Maximum
$fullName_maxWidth = $files.FullName.Length | Measure-Object -Maximum | ForEach-Object Maximum

$Paths = @{
    'Separator' = ' • '
}

$files
| Join-String -sep "`n"

h1 'iter3'
# sys files as black
$files | ForEach-Object {
    Join-String -InputObject $_  -Separator ', ' {
        $text = '{0} <{1:n2}>' -f @($_.Name, $_.Length)
        $text
    }
}
