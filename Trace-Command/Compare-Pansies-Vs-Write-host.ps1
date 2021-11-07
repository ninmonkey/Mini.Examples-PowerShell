#Requires -Module Pansies

# [Example1]: Print trace results to the console
Trace-Command -PSHost -Name ParameterBinding -Expression {
    gi . | Join-String ',' { $_ }
}


# [Example2]: Diffing two different examples

Trace-Command -Name metadata,parameterbinding,cmdlet -Expression {
    Microsoft.PowerShell.Utility\Write-Host 'sdf' -fore
} -FilePath temp:\1

Trace-Command -Name metadata,parameterbinding,cmdlet -Expression {
    Pansies\Write-Host 'sdf' -fore
} -FilePath temp:\2

code --diff (gi temp:\1) (gi temp:\2)
