$RegexNetstat = @'
(?x)
    # parse output from: "netstat -a -n -o
    #   you do not need to skip or filter lines like: "| Select-Object -Skip 4"
    #   correctly captures records with empty States
    ^\s+
    (?<Protocol>\S+)
    \s+
    (?<LocalAddress>\S+)
    \s+
    (?<ForeignAddress>\S+)
    \s+
    (?<State>\S{0,})?
    \s+
    (?<Pid>\S+)$
'@


if (! $NetstatStdout) {
    $NetstatStdout = & netstat -a -n -o
}
# If you're on Pwsh7 you can simplify it using null-*-operators
# $NetstatStdout ??= & netstat -a -n -o

function Format-NetStat {
    param(
        # stdin
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [AllowNull()]
        [Alias('Stdin')]
        [string]$Text
    )

    process {
        if ($Text -match $RegexNetstat) {
            $Matches.Remove(0)
            $hash = $Matches
            $hash['Process'] = Get-Process -Id $hash.Pid
            $hash['ProcessName'] = $hash['Process'].ProcessName
            [pscustomobject]$Matches
        }
    }
}

$Stats = $NetstatStdout | Format-NetStat
$stats | Format-Table

'Results were saved to $stats'
