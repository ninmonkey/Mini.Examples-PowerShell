
function TraceFilter {
    <#
    from the shell even if you redirect debug or even *>&1
        it will never see the debug stream
        running it like this lets you read it
    #>
    $TraceScript = {
        Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression {
            $null | Join-String -sep ', '
        }
    }
    $regex = @{ 'trace' = '^.*tion: 0 :' }

    $runspace = [PowerShell]::Create([InitialSessionState]::CreateDefault2())
    $stdOut = $runspace.AddScript( $TraceScript ).Invoke()
    $runspace.Streams.Debug | ForEach-Object {
        $_ -replace $regex.trace, ''
    }
}

function RegularTrace {
    # same command, using a regular Trace-Command that spams
    # <https://gist.github.com/ninmonkey/eb7610c1ddf9ac8e565387a90a0e11a0>
    Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression {
        $null | Join-String -sep ', '
    }
}

# try:
# RegularTrace
# TraceFilter
