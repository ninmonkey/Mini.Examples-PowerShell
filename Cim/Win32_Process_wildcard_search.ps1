$query = @(
    'Name like "%fire%fo%"'
    'Name like "%pwsh%"'
    'Name like "%powershell%"'
    'Name like "wt"'
)

$query | % {
    Get-CimInstance Win32_Process -filter $_
}
