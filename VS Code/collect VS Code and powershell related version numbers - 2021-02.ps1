# this lists installed, not sure how to filter by enabled ones
H1 'Related Extensions'
code --list-extensions --show-versions | Where-Object { $_ -match 'powersh|pwsh|dotnet|sharp|note|jupy' } | Sort-Object

$PSVersionTable.PSVersion | ForEach-Object tostring
| Label 'pwsh?'

code --version | Join-String -sep ', ' -SingleQuote
| Label 'code'
Get-Module PSScriptAnalyzer | ForEach-Object Version
| Label 'PSScriptAnalyzer'