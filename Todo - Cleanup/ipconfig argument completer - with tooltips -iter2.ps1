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

$SBIpConfig = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # (Get-TimeZone -ListAvailable).Id | Where-Object {
    #     $_ -like "$wordToComplete*"
    # } | ForEach-Object {
    #     "'$_'"
    # }
    # this works
    # @(
    #     '/?'
    #     '/showclassid'
    # )

    # ( '/all', '/All', [CompletionResultType]::Text, 'Display full configuration information.' ),
    # ( '/showclassid6', '/ShowClassId', [CompletionResultType]::ParameterName, 'Modifies the dhcp class id.' )
    @(
        New-CompletionResult '/?' 'Help' ParameterName 'Show all help'
        New-CompletionResult '/?', '/?', ParameterName, 'Display this help message'
        New-CompletionResult '/all', '/All', ParameterName, 'Display full configuration information.'
        New-CompletionResult '/AllCompartments' '/AllCompartments' ParameterName '?'
        New-CompletionResult '/displaydns', '/DisplayDns', ParameterName, 'Display the contents of the DNS Resolver Cache.'
        New-CompletionResult '/flushdns', '/FlushDns', ParameterName, 'Purges the DNS Resolver cache.'
        New-CompletionResult '/registerdns', '/RegisterDns', ParameterName, 'Refreshes all DHCP leases and re-registers DNS names'
        New-CompletionResult '/release', '/Release', ParameterName, 'Release the IPv4 address for the specified adapter.'
        New-CompletionResult '/release6', '/Release6', ParameterName, 'Release the IPv6 address for the specified adapter.'
        New-CompletionResult '/renew' '/Renew' ParameterName 'Renew connetions using a wildcard search'
        New-CompletionResult '/renew', '/Renew', ParameterName, 'Renew the IPv4 address for the specified adapter.'
        New-CompletionResult '/renew6', '/Renew6', ParameterName, 'Renew the IPv6 address for the specified adapter.'
        New-CompletionResult '/setclassid', '/SetClassId', ParameterName, 'Modifies the dhcp class id.'
        New-CompletionResult '/setclassid6', '/SetClassId6', ParameterName, 'Modifies the IPv6 DHCP class id.'
        New-CompletionResult '/showclassid', '/ShowClassId', ParameterName, 'Displays all the dhcp class IDs allowed for adapter.'
        New-CompletionResult '/ShowClassId6', '/ShowClassId6', ParameterName, 'Displays all the IPv6 DHCP class IDs allowed for adapter.'
    )

    # )
    # $CommandList

    # $Result = $CommandList | ForEach-Object {
    #     $CurSet = $_
    #     [CompletionResult]::New( $CurSet[0], $CurSet[1], $CurSet[2], $CurSet[4] )
    # }
    # $Result
}

Register-ArgumentCompleter -Native -CommandName ipconfig -ScriptBlock $SBIpConfig
# Register-ArgumentCompleter -native 'ipconfig.exe' -ParameterName Id -ScriptBlock $scriptBlock

# ipconfig
# ipconfig
