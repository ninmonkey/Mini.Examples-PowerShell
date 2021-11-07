using namespace System.Management.Automation
using namespace System.Collections
<#
New in Pwsh 7.2
    > Beginning in PowerShell 7.2, a new feature was added that allows you to define more generic implementations of parameterized argument completers.
    > By deriving from ArgumentCompleterAttribute, it's <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-7.2#class-based-argument-completers>

Refs:

[IValidateSetValuesGenerator](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.2#dynamic-parameters)

[DynamicParam block](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.2#dynamic-validateset-values)

    DynamicParam {<statement-list>}


additional
    [(https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.idynamicparameters.getdynamicparameters?view=powershellsdk-7.0.0#System_Management_Automation_IDynamicParameters_GetDynamicParameters)
    (https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.idynamicparameters?view=powershellsdk-7.0.0)
    (https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.runtimedefinedparameter?view=powershellsdk-7.0.0)

## notes

[RuntimeDefinedParameter]:
    - attributes of parameter such as (mandatory, postion, ValuefromPipeline)

## see:

    [System.Management.Automation.RuntimeDefinedParameter] | find-member -MemberType Constructor | ft -AutoSize
    [System.Management.Automation.ParameterAttribute] | find-member -MemberType Constructor | ft -AutoSize
    [System.Management.Automation.IValidateSetValuesGenerator]
#>
function New-Animal {
    <#
    .synopsis
        Only cats will show the dynamic parameter -Lives
    .description
        the variable name '$dynParamLives' is used to access the dynamic value
    .parameter Species
        [string] : one of the valid set
    .parameter Lives
        [int32] : Dynamically added when species is a cat
    .example
        PS> New-Animal -Species 'Dog'
        PS> New-Animal -Species 'Cat' -Lives 9

    #>
    [cmdletbinding(PositionalBinding = $false)]
    param(
        [ValidateSet('Cat', 'Dog', 'Other')]
        [parameter(Mandatory, Position = 0)]
        [string]$Species = 'Other'
    )

    DynamicParam {
        if ($Species -eq 'Cat') {
            $pAttr = [ParameterAttribute]::new()
            $pAttr.ParameterSetName = 'SubtypeCat'
            $pAttr.Mandatory = $true
            $pAttr.HelpMessage = '?help Message'      # isn't accessable afaik
            $pAttr.HelpMessageBaseName = '?help Base' # isn't accessable afaik
            $pAttr.Position = 1

            $attrList = [Collections.ObjectModel.Collection[Attribute]]::new()
            $attrList.Add( $pAttr )


            $dynParamLives = [RuntimeDefinedParameter]::new('Lives', [int32], $attrList)

            $paramDict = [RuntimeDefinedParameterDictionary]::new()
            $paramDict.Add( 'Lives', $dynParamLives )

            return $paramDict
        }
    }

    process {
        $lives = ($dynParamLives)?.Value ?? 1
        $animal = [pscustomobject]@{
            'Species' = $Species
            'Lives'   = $Lives
        }
        $animal
    }
}

0..10 | ForEach-Object {
    $_
}
