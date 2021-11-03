BeforeAll {
    # Import-Module dev.nin -Force     
    function Assert-BooleanXOR {
        <#
        .synopsis 
            Compare two cases as bool-XOR
        .description
            The phrase I use to remember how an XOR works is:
    
                One or the other, but not both, and not none.
    
        truth table: <https://en.wikipedia.org/wiki/Exclusive_or> 
    
            0 0 = False
            0 1 = True
            1 0 = True
            1 1 = False
        #>
        param(
            [ValidateNotNull()]
            [Parameter(Mandatory, Position = 0)]
            [bool]$Input1,
            
            [ValidateNotNull()]
            [Parameter(Mandatory, Position = 1)]
            [bool]$Input2
        )
        $Input1 -xor $Input2
    }
    
}

Describe 'Assert-BooleanXOR' {
    It '"<Input1>", <$Input2> Returns "<expected>"' -ForEach @(
        @{ Input1 = $false ; Input2 = $false; Expected = $false }
        @{ Input1 = $false ; Input2 = $true; Expected = $true }
        @{ Input1 = $true ; Input2 = $false; Expected = $true }
        @{ Input1 = $true ; Input2 = $true; Expected = $false }
    ) {
        $assertBooleanXORSplat = @{
            Input1 = $Input1
            Input2 = $Input2
        }

        Assert-BooleanXOR @assertBooleanXORSplat
    }
}