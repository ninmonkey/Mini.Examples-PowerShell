BeforeAll {
    function DoubleIt {
        <#
        .synopsis
            if you run Invoke-Pester **or** even 'f5' will run Pester Tests
        .description
            Sometimes you want one in both, ex: Posting to pastebin, or
            for reproducing errors in a bug report. a single file and runs the code and tests
        #>
        param(
            # Input?
            [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
            [int]$Number
        )
        process {
            $_ * 2
        }
    }

}

Describe 'DoubleIt' {

    It 'Divide by 0' -Tag 'fast' {
        { 10 / 0 }
        | Should -Throw -Because 'Invalid Value'
    }

    It 'Always True and Sleep' -Tag 'slow' {
        Start-Sleep 0.4
        0 | Should -Be 0
    }
}
