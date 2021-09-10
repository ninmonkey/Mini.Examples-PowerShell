<#
About:
    Parse output from Chocolate.
    Find the version numbers of installed apps

Input:

    dotnet4.7.1|4.7.2558.20190226
    fd|8.2.1
    FiraCode|5.2
    fzf|0.27.2
    gh|2.0.0

Output:

    "Name","Version","Raw"
    "dotnet4.7.1","4.7.2558.20190226","dotnet4.7.1|4.7.2558.20190226"
    "fd","8.2.1","fd|8.2.1"
    "fzf","0.27.2","fzf|0.27.2"
    "gh","2.0.0","gh|2.0.0"
#>
$query = & choco @('list', '--local-only', '--limitoutput')
# Or: $query = Invoke-NativeCommand 'choco' -args @('list', '--local-only', '--limitoutput')

$query
| ForEach-Object {
    $Name, $Version = $_ -split '\|'
    [pscustomobject]@{
        Name    = $Name
        Version = $Version
        Raw     = $_
    }
} | Sort-Object Name | ConvertTo-Csv
