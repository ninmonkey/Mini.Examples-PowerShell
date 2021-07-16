<#
.synopsis
    basic PSReadLine filter
.description
    from:
        [JustinGrote](https://twitter.com/JustinWGrote/status/1345181078152040448)
        ![img](https://pbs.twimg.com/media/EEYOSTiXYAYYeiF?format=jpg&name=large)
#>
Set-PSReadLineOption -AddToHistoryHandler {
    param([string]$line)

    $sensitive = 'password|asplaintext|token|key|secret'
    return ($line -notmatch $sensitive)
}
