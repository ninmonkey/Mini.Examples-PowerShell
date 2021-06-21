
<#

tutorial: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7#example-3--register-a-custom-native-argument-completer

#>
$scriptBlock = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # (Get-TimeZone -ListAvailable).Id | Where-Object {
    #     $_ -like "$wordToComplete*"
    # } | ForEach-Object {
    #     "'$_'"
    # }
    @(
        '/?'
        '/all'
        '/showclassid'
    )
}
Register-ArgumentCompleter -Native -CommandName ipconfig -ScriptBlock $scriptBlock
# Register-ArgumentCompleter -native 'ipconfig.exe' -ParameterName Id -ScriptBlock $scriptBlock

# ipconfig
