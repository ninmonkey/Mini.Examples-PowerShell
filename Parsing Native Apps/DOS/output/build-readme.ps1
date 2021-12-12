#Requires -Version 7.0
$App = @{ Root = Get-Item -ea stop $PSScriptRoot }
Set-Location $App.Root
$App += @{
    Readme = Join-Path $App.Root 'readme.generated.md'
}
[hashtable]$template = @{}

'---'

$cmds = Get-Content 'CommandNames.csv' | ConvertFrom-Csv
| Sort-Object { $_.Command -eq 'For' } -Descending
| Where-Object Command
| f 5
# & {

# }
# print one command

$Template.Toc_url = @'
- [{0}](#{0})
'@
$Template.SingleCommand = @'

### {0}

{1}

{2}

'@

$renderHeader = $cmds
| ForEach-Object {
    $cur = $_
    $template.Toc_url -f @( $cur.Command )
}

$renderBody = $cmds
| Where-Object Command
| ForEach-Object {
    $cur = $_
    # $body = Get-ChildItem . "$($cmds[1].Command)*" | Get-Content
    # $body = Get-ChildItem . " | Get-Content
    # | Join-String -sep "`n"
    $body = 'nyi'
    $name = $cur.Command, '.txt' -join ''
    $body = Get-Item $name | Get-Content

    $template.SingleCommand -f @(
        $cur.Command
        $cur.Description
        $body
    )

}


$renderAll = @(
    $renderHeader
    $renderBody
) | Join-String -sep "`n"

$renderAll.length

$renderAll | sc -path $App.Readme
$App.Readme | Get-Item | ForEach-Object fullname
Get-Content $App.Readme | f 300
$app.Readme | Get-Item
