
function toCsv {
    # Normally I recommend not using '$Input', because there's so many edge
    # cases and quirks, but in this case it's okay
    $Input | Join-String -sep ', '
}
function toList {
    $Input | Join-String -sep "`n- " -op "`n- "
}

function h1 { "`n`n#### $args  `n`n" }
function label { param($a, $b) "$a : $b" }


function Format-ShouldProcessSummary {
    <#
    .SYNOPSIS
        summarize using different modes, the the render component onl -- does not invoke ShouldProcess, does not invoke
    .example

    ps> Label 'Mode: ' 'Csv Full'
        renderShouldProcess (_randFiles) Csv
        Label 'Mode: ' 'Csv Short'
        renderShouldProcess (_randFiles).Name Csv
        Label 'Mode: ' 'List Full'
        renderShouldProcess (_randFiles) List
        Label 'Mode: ' 'List Short'
        renderShouldProcess (_randFiles).Name List
    #>
    [Alias('renderShouldProcess')]
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
    # Returns n random items from home ~
    param( [int]$Count = 10 )
    Get-ChildItem -Path '~' -Depth 1 | Get-Random -Count $Count
}

function _showExamples {
    # For real code, I would use ConvertTo-RelativePaths
    # instead of *only* the base name
    Label 'Mode: ' 'Csv Full'
    renderShouldProcess (_randFiles) Csv
    Label 'Mode: ' 'Csv Short'
    renderShouldProcess (_randFiles).Name Csv
    Label 'Mode: ' 'List Full'
    renderShouldProcess (_randFiles) List
    Label 'Mode: ' 'List Short'
    renderShouldProcess (_randFiles).Name List
}
_showExamples
