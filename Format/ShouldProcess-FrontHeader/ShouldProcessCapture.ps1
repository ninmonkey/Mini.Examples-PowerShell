
$Sb_WillFail = {
    function Subject {
        [cmdletBinding(SupportsShouldProcess)]
        param()
        if ($PSCmdlet.ShouldProcess('Target', 'Operation')) {
            'do stuff ✔'
        } else {
            'failure ❌'
        }
    }
    Subject -Confirm
}

$sbWrite = {
    'default 🐈'
    [console]::Write('write out 🙊')
    '"de"-bug 🐛' | Write-Debug
    'info 📚' | Write-Debug
}

$sbTrace = {
    Trace-Command -Command { Get-Item '.' } -Name ParameterBinding -PSHost
}

$curSb = $sbTrace
$runspace = [PowerShell]::Create([InitialSessionState]::CreateDefault2())
# $stdOut = $runspace.AddScript( $TraceScript ).Invoke()
$stdOut = $runspace.AddScript( $curSb ).Invoke()
$runspace.Streams.Debug | ForEach-Object {
    'Message'
    $_.Message
    'Invoke'
    $_.InvocationInfo
    'Pipe'
    $_.PipelineIterationInfo
}

return
