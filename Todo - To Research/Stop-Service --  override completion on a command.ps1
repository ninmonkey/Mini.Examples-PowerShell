$s = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $services = Get-Service | Where-Object { $_.Status -eq "Running" -and $_.Name -like "$wordToComplete*" }
    $services | ForEach-Object {
        New-Object -Type System.Management.Automation.CompletionResult -ArgumentList $_.Name,
        $_.Name,
        "ParameterValue",
        $_.Name
    }
}
Register-ArgumentCompleter -CommandName Stop-Service -ParameterName Name -ScriptBlock $s