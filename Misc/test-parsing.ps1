function _test_Write_MarkdownTableColumns {
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

    0..$NumColumns | Join-String @splatEmptyColumn
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

_test_Write_MarkdownTableColumns 3
