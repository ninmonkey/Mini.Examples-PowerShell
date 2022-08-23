<# from: <https://github.com/SeeminglyScience> #>

function Test-ShouldProcess {
    [cmdletbinding(SupportsShouldProcess, PositionalBinding = $false)]
    param()

    end {
        $null = $PSCmdlet.ShouldProcess(
            'description',
            'warning',
            'caption'
        )
    }
}

Test-ShouldProcess -WhatIf

Test-ShouldProcess -Confirm
