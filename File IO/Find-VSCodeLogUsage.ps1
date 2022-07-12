$hasFunc_EnvPath = [bool](Get-Command -ea 'ignore' 'toEnvPath')
function _measureLogUsage {
    <#
    .synopsis
        grab a few metrics, not performant, not cached
    #>
    [OutputType('examples.LogSizeSummary')]
    [cmdletbinding()]
    param(
        [string]$Path, [string]$Label
    )
    $Found = Get-ChildItem -Path (Get-Item -ea 'Stop' $Path) -Filter '*.log' -Recurse
    | Sort-Object LastWriteTime -Descending

    $Bytes = ($Found | Measure-Object -Property Length -Sum).Sum

    $meta = @{
        PSTypeName     = 'examples.LogSizeSummary'
        Label          = $Label
        Path           = Get-Item $Path | ForEach-Object FullName | ForEach-Object {
            if ($hasFunc_EnvPath) {
                $_ | toEnvPath
            } else {
                $_
            }
        }
        Size           = '{0:n2} MB' -f ($bytes / 1mb )
        Bytes          = $Bytes
        Logs           = $Found
        LogCount       = $Found.count
        OldestCreated  = $Found | Sort-Object CreationTime | Select-Object -First 1 | ForEach-Object CreationTime
        OldestModified = $Found | Sort-Object LastWriteTime | Select-Object -First 1 | ForEach-Object LastWriteTime
        NewestCreated  = $Found | Sort-Object CreationTime | Select-Object -Last 1 | ForEach-Object CreationTime
        NewestModified = $Found | Sort-Object LastWriteTime | Select-Object -Last 1 | ForEach-Object LastWriteTime
    }
    if ( $hasFunc_EnvPath ) {
        $meta['Path'] = $meta['Path'] | toEnvPath
    }
    return [pscustomobject]$meta
}

Update-TypeData -TypeName 'examples.LogSizeSummary' -DefaultDisplayPropertySet @(
    'Label', 'Size', 'LogCount'
    'Path',
    'NewestCreated', 'NewestModified'
    'OldestCreated', 'OldestModified'
) -Force -ea ignore

# $cacheSlow ??= _measureLogUsage -Path $extVersion -Label $extVersion.Name

$findAllExtensions = Get-ChildItem $Env:UserProfile/.vscode/extensions/ms-vscode.powershell*
function Reset {
    #reset for another search
    $script:cache = $Null; $script:cache2 = $Null; 'Cleared.'
}
$Results = @(
    foreach ($extVersion in $findAllExtensions) {
        _measureLogUsage -Path $extVersion -Label "Only $($extVersion.Name)"
    }

    $cache ??= _measureLogUsage -Path "$env:APPDATA/code" -Label '/AppData/Code'
    $cache
    $cache2 ??= _measureLogUsage -Path "$Env:UserProfile/.vscode/extensions" -Label 'All ⅀ $Env:UserProfile/.vscode/extensions'
    $cache2
) | Sort-Object Bytes -Descending
$Results | Format-List Path, Label, Size, LogCount
$Results | Format-Table Size, Path
$Results | Format-List Path, Label, Oldest*, Newest*
$Results | Format-Table label, Size, Oldest*, newest*
$Results | Format-Table Path, Size, Label, *modified
$Results | Sort-Object Path | Format-Table Path, Size, Label, *modified
# $Results | Format-Table Label, Oldest*, Newest*
'$Results are cached, Reset() will clear the cache for another run'


