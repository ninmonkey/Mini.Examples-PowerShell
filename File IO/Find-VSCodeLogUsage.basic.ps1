
# first pass from console
$logs ??= Get-ChildItem $env:APPDATA/code *.log -Recurse
| Sort-Object LastWriteTime

$root2 = Get-ChildItem $Env:UserProfile/.vscode/extensions/ms-vscode.powershell*
$logs2 = Get-ChildItem $root2 *.log -Recurse | Sort-Object LastWriteTime

$perExt = @{}
foreach ($curRoot in $root2) {
    $found = Get-ChildItem $curRoot *.log -Recurse | Sort-Object LastWriteTime
    $perExt[ $curRoot.Name ] = '{0:n2} MB' -f ( ($found | Measure-Object -Property Length -Sum).Sum / 1mb )
}
$perExt['a'] = '{0:n2} MB' -f ((($logs2 | Measure-Object -Property Length -Sum).Sum / 1mb ))
$perExt['b'] = '{0:n2} MB' -f ((($logs | Measure-Object -Property Length -Sum).Sum / 1mb ))
$perExt | Format-List
