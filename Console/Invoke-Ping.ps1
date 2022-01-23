
function Invoke-Ping {
    param(
        # server / ip
        [Parameter(Mandatory, Position = 0)][string]$TargetName,

        # optionally lookup
        [switch]$ResolveHost
    )

    $binPing = Get-Command -ea stop 'ping' -CommandType Application
    [object[]]$PingArgs = @()

    $Config = @{
        Count       = 1
        ResolveHost = $True
    }
    # Conditionally build up command line args
    $PingArgs += @(

        if ($Config.ResolveHost) {
            '-a'
        }
        $PingArgs += @(
            if ($Config.Count) {
                '-n', $Config.Count
            }
        )

        $TargetName
    )

    # if PS7
    $PingArgs | Join-String -sep ' ' -op 'ping.exe '

    & $binPing @PingArgs
}

# Invoke-Ping -TargetName google.com -ResolveHost

# ping -n 1 -a google.com
