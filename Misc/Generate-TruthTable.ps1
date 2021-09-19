<#
    About:

        A simple truth table example spiraled into a Markdown Table generator.
        Color is included.
#>

# Cartesian join of ($true, $false) on itself
$samples = 0..1 | ForEach-Object {
    [bool]$Foreground = $_
    0..1 | ForEach-Object {
        [bool]$Background = $_

        [pscustomobject]@{
            'Fg' = $Foreground
            'Bg' = $Background

        }
    }
}

$ConfigTT = @{
    ExportMd       = $true
    # SingleTestOnly = $True
    SingleTestOnly = $False
    MDInjectColor  = $true
}


function Test-Xor {
    <#
    .synopsis
        boolean XOR logical test
    .notes
        see: <https://en.wikipedia.org/wiki/Exclusive_or>
    #>
    param([bool]$A, [bool]$B)

    $A -xor $B
}

function _Write_MarkdownTableColumns {
    <#
        .synopsis
            GFW markdown table headers
        .example
            PS> _Write-MarkdownTableColumns 5

                |  -  |  -  |  -  |  -  |  -  |

        #>
    param(
        # How many columns / cells ?
        [Parameter(Mandatory, position = 0)]
        [ValidateRange('Positive')]
        [int]$NumColumns
    )

    end {
        $splatEmptyColumn = @{
            Separator    = ' | '
            OutputPrefix = '| '
            OutputSuffix = ' | '
            Property     = { ' - ' }
        }

        1..$numColumns | Join-String @splatEmptyColumn
    }
}

function _write_MarkdownHeader {
    <#
    .synopsis
        markdown headers
    .example

        PS> mdHeader 3 'About: '

            ### About:

    #>
    [alias('mdHeader')]
    [cmdletbinding()]
    param(
        # Heading level
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(1, 6)]
        [int]$HeaderLevel,

        [Parameter(Mandatory, Position = 1)]
        [string]$Text
    )

    $prefix = '#' * $HeaderLevel
    $template = '{0} {1}'
    $template -f @(
        $Prefix
        $Text
    ) | Join-String -op "`n`n" -os "`n`n"
}

function Format-ResultSummary {
    [cmdletbinding()]
    param()
`
        $results = $samples | ForEach-Object {
        $item = $_
        $test_result = Test-Xor $item.Fg $item.Bg
        $title = 'A XOR B'
        Add-Member -InputObject $item  -NotePropertyName $title -NotePropertyValue $test_result -PassThru

        if ($ConfigTT.SingleTestOnly) {
            return
        }

        $test_result = ! $Item.Fg -and ! $Item.Bg
        $title = '! A -and ! B'
        Add-Member -InputObject $item  -NotePropertyName $Title -NotePropertyValue $test_result

        $test_result = ! ($Item.Fg) -and ! ($Item.Bg)
        $title = '! (A) -and ! (B)'
        Add-Member -InputObject $item  -NotePropertyName $Title -NotePropertyValue $test_result

        $test_result = (! $Item.Fg) -and (! $Item.Bg)
        $title = '(! A) -and (! B)'
        Add-Member -InputObject $item  -NotePropertyName $Title -NotePropertyValue $test_result

        # ----

        $test_result = ! $Item.Fg -or ! $Item.Bg
        $title = '! A -or ! B'
        Add-Member -InputObject $item  -NotePropertyName $Title -NotePropertyValue $test_result

        $test_result = ! ($Item.Fg) -or ! ($Item.Bg)
        $title = '! (A) -or ! (B)'
        Add-Member -InputObject $item  -NotePropertyName $Title -NotePropertyValue $test_result

        $test_result = (! $Item.Fg) -or (! $Item.Bg)
        $title = '(! A) -or (! B)'
        Add-Member -InputObject $item  -NotePropertyName $Title -NotePropertyValue $test_result
    }

    # quick hack, using csv to simplify writing headers
    $ColumnNames = $results[0].PSObject.Properties.Name
    $ColumnCount = $ColumnNames.Count
    # header
    @(
        $splat_ColumnHeaders = @{
            OutputPrefix = '| '
            Separator    = ' | '
            OutputSuffix = ' |'
        }

        $ColumnNames | Join-String @splat_ColumnHeaders
        # $ColumnNames | Join-String @splat_ColumnHeaders | Write-Debug

        _write_MarkdownTableColumns $ColumnCount
        # _write_MarkdownTableColumns $ColumnCount | Write-Debug

        $results | Select-Object -Skip 0 | ForEach-Object {
            $record = $_
            $row = $ColumnNames | ForEach-Object {
                $curCol = $_
                $record.$curCol
                if ($null -eq $record.$curCol) {
                    Write-Error "Property '$curCol' was $null!" -Category InvalidData -TargetObject $record
                }
            }

            $splat_TableRecord = @{
                OutputPrefix = '| '
                OutputSuffix = ' |'
                Separator    = ' | '
                Property     = { $_ }
            }


            $row | Join-String @splat_TableRecord

            # $row | Join-String @splat_TableRecord | Write-Debug


        }
    ) | Join-String -sep "`n"
}


# See also:
#     <https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting>
#     with <https://docs.microsoft.com/en-us/dotnet/api/system.text.stringbuilder.appendformat?view=net-5.0>

[Text.StringBuilder]$accumStr = [Text.StringBuilder]::new()
[void]$accumStr.AppendLine( (mdHeader 2 'Truth Table: XOR') )
[void]$accumStr.AppendLine( "XOR means: A or B is true, but neither both and neither none`n" )
[void]$accumStr.AppendLine( (Format-ResultSummary) )
$FinalText = $accumStr | Join-String

'Config'; $ConfigTT | Format-Table

hr; $FinalText; hr;
if ($ConfigTT.ExportMd) {
    try {

        $DestPath_Single = (Join-Path $PSScriptRoot '.output/tt_xor.md')
        $DestPath_Many = (Join-Path $PSScriptRoot '.output/tt_many.md')
        $DestPath = ($ConfigTT.SingleTestOnly) ? $DestPath_Single : $DestPath_Many
        $FinalText | Set-Content -Path $DestPath
        "Wrote to: '$DestPath'"


        if (! $ConfigTT.MDInjectColor) {
            return
        }

        # quick hack to add color, should be in the table builder
        $HtmlColoredText = $FinalText -replace
        '\bFalse\b', '<span style=''color:red;''>False</span>' -replace
        '\bTrue\b', '<span style=''color:green;''>True</span>'

        $DestPath_Single = (Join-Path $PSScriptRoot '.output/tt_xor-color.md')
        $DestPath_Many = (Join-Path $PSScriptRoot '.output/tt_many-color.md')
        $DestPath = ($ConfigTT.SingleTestOnly) ? $DestPath_Single : $DestPath_Many
        $HtmlColoredText | Set-Content -Path $DestPath
        "Wrote to: '$DestPath'"
    }
    catch {

        if ($_.Exception.ToString() -match 'system.io') {
            throw "You can disable writing using '`$ConfigTT.ExportMd'"
        }
        else {
            $PSCmdlet.ThrowTerminatingError($_)
        }

    }
}
