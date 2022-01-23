
function Invoke-Ping {
    param(
        # server / ip
        [Parameter(Mandatory, Position = 0)]
        [string]$TargetName,

        # optionally lookup
        [switch]$ResolveHost
    )

    $binPing = Get-Command -ea stop 'ping' -CommandType Application
    [object[]]$PingArgs = @()

    $Config = @{
        Count       = 3
        ResolveHost = $True
    }
    # Conditionally build up command line args
    $PingArgs += @(

        if ($Config.ResolveHost) {
            '-a'
        }
        $PingArgs += @(
            '-n', $Config.Count
            $Config.Count
        )

        $TargetName
    )

    # if PS7
    $binPing | Join-String -sep ' ' -op 'ping.exe '

    & $binPing @PingArgs


}
