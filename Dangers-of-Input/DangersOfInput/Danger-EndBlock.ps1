
function dangerTest2A {
    # Get a list of files, ignore folders
    end {
        $Input | Join-String -sep ', ' -SingleQuote
    }
}
function dangerTest2B {
    # Get a list of files, ignore folders
    begin {
    }
    process {
        $Total++
    }
    end {
        $Total
        $Input | Join-String -sep ', ' -SingleQuote
    }
}
Hr
$Names = 'ben', 'sue', 'fred'

Label 'Function' 'DangerTest2A'
$names | DangerTest2A
<#
outputs:

    'ben', 'sue', 'fred'
#>
Hr

Label 'Function' 'DangerTest2B'
$Names | DangerTest2B
<#
outputs:

    3
#>
