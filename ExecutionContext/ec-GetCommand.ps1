
$tinfo_cmd = [Management.Automation.CommandTypes]::Filter
$what = '_enumerateMyModule'
$ExecutionContext.InvokeCommand.GetCommand( $what, [System.Management.Automation.CommandTypes]::Function )

write-warning 'when finished save to <C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\executionContext\ec-GetCommand.ps1> or save from there to here'
