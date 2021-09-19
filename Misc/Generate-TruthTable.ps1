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
    ExportMd = $true
}

function Test-what {
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

    # end {

    $splatEmptyColumn = @{
        Separator    = ' | '
        OutputPrefix = '| '
        OutputSuffix = ' | '
        Property     = { ' - ' }
    }

    1..$numColumns | Join-String @splatEmptyColumn
    # }
    # refactor: $splat_ColumnHeaders and $splatEmptyColumn are almost identical
    # $splatEmptyColumn = @{
    #     Separator    = ' | '
    #     OutputPrefix = '| '
    #     OutputSuffix = ' | '
    #     Property     = { ' - ' }
    # }

    # 1..$numColumn | Join-String @splatEmptyColumn { $_ }
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

    $results = $samples | ForEach-Object {
        $item = $_
        $test_result = Test-Xor $item.Fg $item.Bg
        Add-Member -InputObject $item  -NotePropertyName 'XOR Output' -NotePropertyValue $test_result -PassThru
    }

    # quick hack, using csv to simplify writing headers
    $ColumnNames = $results[0].PSObject.Properties.Name
    $ColumnCount = $ColumnNames.Count

    # $results[0] | Select-Object $ColumnNames

    # header
    @(
        $splat_ColumnHeaders = @{
            OutputPrefix = '| '
            Separator    = ' | '
            OutputSuffix = ' |'
        }

        $ColumnNames | Join-String @splat_ColumnHeaders
        $ColumnNames | Join-String @splat_ColumnHeaders | Write-Debug

        _write_MarkdownTableColumns $ColumnCount
        _write_MarkdownTableColumns $ColumnCount | Write-Debug

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

            $row | Join-String @splat_TableRecord | Write-Debug


        }
    ) | Join-String -sep "`n"
}


$accumStr = [Text.StringBuilder]::new()

# Truth table results
$template_page = @'
{0}
{1}
'@

$accumStr.Append( (mdHeader 2 'Truth Table: XOR') )

$accumStr.Append( (Format-ResultSummary) )
# $markdown = Format-ResultSummary
# $FinalText = $template_page -f @($markdown)
# $FinalText

$accumStr

hr

if ($ConfigTT.ExportMd) {
    $DestPath = (Join-Path $PSScriptRoot '.output/tt_xor.md')
    $FinalText | Set-Content -Path $DestPath
    "Wrote to: '$DestPath'"
}
# $results = Format-ResultSummary -debug
# $results
