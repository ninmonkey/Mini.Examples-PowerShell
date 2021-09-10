<#
Note:
    Other endpoints will directly return JSON, without needing to parse:
    like this (There wasn't one for 'gist list'.)

    PS> gh repo list PowerShell --json='name,diskUsage,forkCount,description'

#>

$stdout ??= gh gist list -L 300 #
$query = $stdout
| ForEach-Object {
    $record = $_ -split '\t'
    $src = $record[4]
    $maybeDatetime = try { [datetime]::parse( $src ) } catch { $src }
    [pscustomobject]@{
        Hash     = $record[0]
        Title    = $record[1]
        Files    = $record[2]
        IsPublic = $record[3]
        Date     = $maybeDatetime
        #$record[4] -as 'datetime'
    }
}
$query | Select-Object -First 4

<#
Output:

    Hash     : 4138585f97bd300f454d13d43d8512f5
    Title    : Javascript Cheatsheet ▸ Array
    Files    : 1 file
    IsPublic : secret
    Date     : 9/5/2021 2:36:41 PM

    Hash     : 80aae76fa5d1f60731bae5b9c58e2093
    Title    : Custom PSScriptAnalyzer Rules -- Nightmares wishlist.md
    Files    : 1 file
    IsPublic : public
    Date     : 8/24/2021 4:02:28 PM

#>
