<#
from:   Stroniax <https://discord.com/channels/180528040881815552/447476910499299358/908132117878288385>
#>
It 'should have a completer for <Parameter.Name>' -ForEach @(
    $ignore = @([System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters)
    $Command.Parameters.Values
    | Where-Object {
        $_.Name -notin $ignore -and
        $_.Name -notlike '*path' -and
        $_.ParameterType -notlike [switch] -and
        !$_.ParameterType.IsAssignableTo([Enum])
    }
    | ForEach-Object {
        @{ Parameter = $_ }
    }
) {
    $Completer = $Parameter.Attributes
    | Where-Object {
        $_ -is [ValidateSet] -or
        $_ -is [ArgumentCompletions] -or
        $_ -is [ArgumentCompleter] -or
        $_ -is [System.Management.Automation.ArgumentCompleterFactoryAttribute]
    }
    $Completer | Should -Not -BeNullOrEmpty -Because 'parameters should offer relevant argument completion'
}