<#
.synopsis
    Execute a command, pausing if a regex appears
#>

$Pattern = 'adapter(?<Label>.*)'
ipconfig /all | ForEach-Object {
    $curLine = $_
    if ($curLine -match $Pattern) {
        Write-Host -fore red "Found: $($Matches.Label)"
        Read-Host -Prompt 'waiting...'
    }
    $curLine
}
