using namespace System.Management.Automation;
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

function newCompletionResult($completionText, $listItemText, $resultType, $tooltip) {
    [completionresult]::new($completionText, $listItemText, $resultType, $tooltip )
}

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

    $CommandList = (
        ( '/all', '/All', [CompletionResultType]::Text, 'Display full configuration information.' ),
        ( '/showclassid6', '/ShowClassId', [CompletionResultType]::ParameterName, 'Modifies the dhcp class id.' )
    )

    $Result = $CommandList | ForEach-Object {
        $CurSet = $_
        [CompletionResult]::New( $CurSet[0], $CurSet[1], $CurSet[2], $CurSet[4] )
    }
    $Result
}
Register-ArgumentCompleter -Native -CommandName ipconfig -ScriptBlock $scriptBlock
# Register-ArgumentCompleter -native 'ipconfig.exe' -ParameterName Id -ScriptBlock $scriptBlock

# ipconfig
ipconfig


break
$CommandList = (
    ( '/all', '/All', [CompletionResultType]::Text, 'Display full configuration information.' ),
    ( '/showclassid6', '/ShowClassId', [CompletionResultType]::Text, 'Modifies the dhcp class id.' )


)

$CommandList | ForEach-Object {
    "Item: {0}" -f $_[1]
}

hr 10
$CommandList = (
    ( '/all', '/All', [CompletionResultType]::Text, 'Display full configuration information.' ),
    ( '/showclassid6', '/ShowClassId', [CompletionResultType]::Text, 'Modifies the dhcp class id.' )
)

$CommandList | ForEach-Object {
    [CompletionResult]::New( $_ )
}