using namespace System.Management.Automation;

. "$PSScriptRoot\New-CompletionResult.ps1"

<#

tutorial: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7#example-3--register-a-custom-native-argument-completer

[CompletionResult](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresult?view=powershellsdk-7.0.0)

[CompletionResult: ctor](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresult.-ctor?view=powershellsdk-7.0.0#System_Management_Automation_CompletionResult__ctor_System_String_System_String_System_Management_Automation_CompletionResultType_System_String_)

[CompletionResultType Enum](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.completionresulttype?view=powershellsdk-7.0.0)

    list: Text, History, Command, ProviderItem, ProviderContainer, Property, Method, ParameterName, ParameterValue, Variable, Namespace, Type, Keyword, DynamicKeyword


## CompletionResult type:
    completionText (String)
        value sent to the command

    listItemText (String)
        text visible in 'menucomplete'. value does not affect final command

    resultType (Enum)
        type

    tooltip (String)
        tooltip on menu


#>

$scriptBlock = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # (Get-TimeZone -ListAvailable).Id | Where-Object {
    #     $_ -like "$wordToComplete*"
    # } | ForEach-Object {
    #     "'$_'"
    # }
    # @(
    #     '/?'
    #     '/all'
    #     '/showclassid'
    # )

    # $singleResult = [completionresult]::new('/all', 'All', [CompletionResultType]::Text, 'Display full configuration information' )
    # $singleResult
    # $CommandList = @(
    #     (
    #         '/all',
    #     )
    # )
    # $t = @{
    #     Param = [CompletionResultType]::Text
    # }

    # $CommandList = (
    # New-CompletionResult '/all', '/All', $t.Param , 'Display full configuration information'
    $x1 = New-CompletionResult '/showclassid6', '/ShowClassId6', [CompletionResultType]::Text, 'Display full configuration information' -Debug
    $x1 = New-CompletionResult '/all', '/All', [CompletionResultType]::ParameterName, 'all' -Debug

    $x1
    # ( '/all', '/All', [CompletionResultType]::Text, 'Display full configuration information.' ),
    # ( '/showclassid6', '/ShowClassId', [CompletionResultType]::ParameterName, 'Modifies the dhcp class id.' )


    # )
    # $CommandList

    # $Result = $CommandList | ForEach-Object {
    #     $CurSet = $_
    #     [CompletionResult]::New( $CurSet[0], $CurSet[1], $CurSet[2], $CurSet[4] )
    # }
    # $Result
}
Register-ArgumentCompleter -Native -CommandName ipconfig -ScriptBlock $scriptBlock -Debug
# Register-ArgumentCompleter -native 'ipconfig.exe' -ParameterName Id -ScriptBlock $scriptBlock

# ipconfig
# ipconfig
