<#

From the docs: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-7.2#argumentcompleter-script-block

#>

function MyArgumentCompleter {
    param ( $commaName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters )

    $possibleValues = @{
        Fruits     = @('Apple', 'Orange', 'Banana')
        Vegetables = @('Tomato', 'Squash', 'Corn')
    }

    if ($fakeBoundParameters.ContainsKey('Type')) {
        $possibleValues[$fakeBoundParameters.Type] | Where-Object {
            $_ -like "$wordToComplete*"
        }
    }
    else {
        $possibleValues.Values | ForEach-Object { $_ }
    }
}

function Test-ArgumentCompleter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Fruits', 'Vegetables')]
        $Type,
    
        [Parameter(Mandatory = $true)]
        [ArgumentCompleter({ MyArgumentCompleter @args })]
        $Value
    )
}