function Test-ShouldProcessWild {
    <#
        Is this silly? Yes.
        Is it excessive use of pipelines? Yes.
    #>
    [cmdletbinding(SupportsShouldProcess, PositionalBinding = $false)]
    param()

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
                $

                $files
                | Join-String -sep "`n  " -op "`n  " -os "`n" {
                    $curFile = $_
                    @(
                        '$Src/'

                        $curFile | Format-RelativePath -BasePath $BasePath
                        | New-Text -fg green

                        ' -->  '
                        | New-Text -fg yellow

                        '$Dest/'
                        $curFile | Format-RelativePath -BasePath $BasePath
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
    }
}

# Get-ChildItem ~ -Depth 2 | Get-Random -Count 3
Test-ShouldProcessWild -WhatIf

Test-ShouldProcessWild -Confirm
