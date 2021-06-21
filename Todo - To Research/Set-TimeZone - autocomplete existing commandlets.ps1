$scriptBlock = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    (Get-TimeZone -ListAvailable).Id | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {
        "'$_'"
    }
}
Register-ArgumentCompleter -CommandName Set-TimeZone -ParameterName Id -ScriptBlock $scriptBlock

ipconfig
