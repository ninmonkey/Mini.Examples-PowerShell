
function toCsv {
    # Normally I recommend not using '$Input', because there's so many edge
    # cases and quirks, but in this case it's okay
    $Input | Join-String -sep ', '
}
function toList {
    $Input | Join-String -sep "`n- " -op "`n- "
}
function Test-ShouldProcessWild {
    <#
        Is this silly? Yes.Is it excessive use of pipelines?  Probably.
    #>
    [cmdletbinding(SupportsShouldProcess, PositionalBinding = $false)]
    param(
        #
        [ValidateSet('List', 'Csv')]
        [Parameter()]$OutputFormat = 'List',

        [switch]$ShortNames
    )
    process {

    }
}

function renderShouldProcess {
    <#
    .SYNOPSIS
        render component only
    #>
    [cmdletbinding()]
    param(
        # files
        [Parameter(Position = 0)]
        [object[]]$InputObject,

        # text formt mode
        [ValidateSet('List', 'Csv')]
        [Parameter(Mandatory, position = 1)]
        $OutputFormat = 'List'
        # # do not use full names
        # [switch]$ShortNames
    )

    switch ($OutputFormat) {
        'List' { $InputObject | Sort-Object | toList }
        'Csv' { $InputObject | Sort-Object | toCsv }
        default { $InputObject | Sort-Object }
    }
    # $base = Get-Item '~'
    # Get-ChildItem '~' -Depth 1 -File
    # | Get-Random -Count 20
    # | Ninmonkey.Console\ConvertTo-RelativePath -BasePath
    # | UL
}
function _randFiles {
    param( [int]$Count = 10 )
    Get-ChildItem -Path '~' -Depth 1 -File | Get-Random -Count $Count
}
Label 'Mode: ' 'Csv Full'
renderShouldProcess (_randFiles) Csv
Label 'Mode: ' 'Csv Short'
renderShouldProcess (_randFiles).Name Csv
Label 'Mode: ' 'List Full'
renderShouldProcess (_randFiles) List
Label 'Mode: ' 'List Short'
renderShouldProcess (_randFiles).Name List



return

function Test-ShouldProcessWild_old {
    <#
        Is this silly? Yes.
        Is it excessive use of pipelines? Yes.
    #>
    [cmdletbinding(SupportsShouldProcess, PositionalBinding = $false)]
    param(
        #
        [Parameter()]$OutputFormat = 'List'

    )

    begin {
    }
    end {
        $Warning = ''
        $Caption = ''
        $Desc = ''
        $BasePath = Get-Item ~
        $files = Get-ChildItem $BasePath -Depth 2 | Select-Object -First 10
        if ($WhatIfPreference) {
            <#
            -WhatIf only displays '$desc'
            #>
            $Desc = @(
                "`n`n## Copy Files? ## `n" | New-Text -fg yellow


                $files
                | Join-String -sep "`n  " -op "`n  " -os "`n" {
                    $curFile = $_
                    @(
                        '$Src/'

                        $curFile | Ninmonkey.Console\Format-RelativePath -BasePath $BasePath
                        | New-Text -fg green

                        ' -->  '
                        | New-Text -fg yellow

                        '$Dest/'
                        $curFile | Ninmonkey.Console\Format-RelativePath -BasePath $BasePath
                        | New-Text -fg green

                    ) | Join-String
                }
                # | New-Text -fg green
            ) | Join-String
        } else {
            <#
            -Confirm uses all 3
            #>
            $Desc = "`n`n  Copy Files?" | New-Text -fg blue
            $caption = '    bad ⛔' | New-Text -fg red -bg gray20
            $warning = "`n    Caption`n" | New-Text -fg darkyellow

        }

        $null = $PSCmdlet.ShouldProcess(
            $Desc, $Warning, $Caption
        )
        $null = $PSCmdlet.ShouldProcess(
            $Desc, $Warning, $Caption
        )
    }
}

# Get-ChildItem ~ -Depth 2 | Get-Random -Count 3
Test-ShouldProcessWild -WhatIf

Test-ShouldProcessWild -Confirm
