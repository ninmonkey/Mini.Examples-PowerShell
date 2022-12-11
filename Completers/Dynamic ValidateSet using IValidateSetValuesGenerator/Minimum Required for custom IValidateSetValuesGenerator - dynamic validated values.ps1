#Requires -Version 6.0
<#
    [IValidateSetValuesGenerator] requires Powershell 6+
    You can find examples using Pwsh7 methods in: <https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#dynamic-validateset-values-using-classes>
#>

<#
.SYNOPSIS
    generates completions for 'Get-Employee'
#>
Class EmployeeNames : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
         $json = '{ "names": [ "Bob", "Jen", "Kurt" ] }'
         | ConvertFrom-Json

         return [string[]] $Json.Names
    }
}

function Get-Employee { 
    <#
    .SYNOPSIS
        Autocompletes, Coerces, and Validatess values that act like an enum with ValidateSet()
    #>
    Param(
        [ValidateSet([EmployeeNames])]
        [string]$EmployeeName
    )   
}