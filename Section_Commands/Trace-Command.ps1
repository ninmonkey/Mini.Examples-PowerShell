$A = 'i*'
Trace-Command ParameterBinding { Get-Alias $Input } -PSHost -InputObject $A
Hr 2
# Start-Sleep 0.3
$src = Get-ChildItem . -File | Select-Object -First 1
Trace-Command ParameterBinding -PSHost {
    # ForEach-Object -MemberName length -InputObject $src
    ForEach-Object -MemberName length -InputObject $src
}

Hr 2

$src = Get-ChildItem
| Select-Object -First 1

# $src | Where-Object Name -Match '.'
Trace-Command ParameterBinding -PSHost {
    # ForEach-Object -MemberName length -InputObject $src
    Where-Object Name -Match 'x' -InputObject $src
}

Hr 2

# $src | Where-Object Name -Match '.'
$src = 'foo,bar,cat'
Trace-Command ParameterBinding -PSHost  -InputObject $src {
    ForEach-Object split 'a' -InputObject $src
    # -InputObject $src
    # ForEach-Object -MemberName length -InputObject $src
    # | ForEach-Object Split 'a'
    # Where-Object Name -Match 'x' -InputObject $src
}


Hr 10

$traceNinCommandSplat = @{
    # Silent     = $true # hides STDOUT
    # AutoOpen   = $true # open results in code
    Expression = {
        ForEach-Object split 'a' -InputObject $src
    }
}

Trace-NinCommand @traceNinCommandSplat
