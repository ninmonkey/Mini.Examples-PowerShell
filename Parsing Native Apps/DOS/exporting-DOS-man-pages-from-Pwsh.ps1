#Requires -Version 7.0

$App = @{ Root = Get-Item -ea stop $PSScriptRoot }
Set-Location $App.Root
$App += @{
    Export = Join-Path $App.Root 'output'
}

function New-ExportDocSplat {
    param($Label)

    $splatDoc = @{
        # Path                   = 'cmd'
        NoNewWindow            = $true
        RedirectStandardOutput = Join-Path $App.Export "$Label.txt"
        RedirectStandardError  = Join-Path $App.Export "$Label.stderr.txt"
    }
    $splatDoc
}

'CMD', 'FOR' | ForEach-Object {
    $Label = $_
    $exportSplat = New-ExportDocSplat -label $Label
    Start-Process 'cmd' @exportSplat -args @('/C', $Label, '/?')
    @(
        'Wrote: '
        @(
            $exportSplat.RedirectStandardOutput
            $exportSplat.RedirectStandardError
        )
        # | To->RelativePath
        | Join-String -sep "`n" -DoubleQuote
    )
}

# Remove empty errors
Get-ChildItem $App.Export *stderr* | Where-Object Length -EQ 0 | Remove-Item
