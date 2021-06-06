
function Get-Fruit_WithoutTooltips {
    param (
        # FruitName?
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter( {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                $ValidValues = @('apple', 'banana', 'etc')
                return $ValidValues -like "$WordToComplete*"
            }
        )]
        [string[]]$Fruit
    )

    process {
        $PSBoundParameters | Format-HashTable -Title 'PSBoundParams'
        $Fruit | Join-String -sep "`n- " -OutputPrefix "`n- " | Label 'FruitNames'
    }

}


Get-Fruit_WithoutTooltips  banana, apple, other


Write-Nin

@'
see also

<Can that scriptblock return a [CompletionResult] instead for tooltips?
I'm not sure from looking at the docs https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.argumentcompleterattribute?view=powershellsdk-7.0.0>

'@