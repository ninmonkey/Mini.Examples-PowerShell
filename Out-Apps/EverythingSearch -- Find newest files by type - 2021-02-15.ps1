@'
- if Everything is installed <https://www.voidtools.com/support/everything/searching/>
- and 'es:' protocol is enabled, then:
'@

function Invoke-EverythingSearch {
    param(
        # Extension
        [Parameter(Position = 0)]
        [string[]]$Extension = @(
            'pbix'
            'pq'
            'ps1'
            'md'
            'png'
            'json'
        ),
        # WhatIf
        [Parameter()][switch]$WhatIf

    )
    begin {
        $Extension = $Extension | Sort-Object -Unique
        $Config = @{
            ImplicitlyWrapQueries = $false
            <#
            makes things safer, preventing accidental and/or mixups when dynamic and nested

            arg1
                = ext:ps1 | dm:today
            arg2
                = 'ext:pq'

            operator: OR

            wrapped:
                (ext:ps1 | dm:today) | ext:pq

            not:
                ext:ps1 | dm:today | ext:pq
            #>

        }
    }
    process {
        <#
        polyfill/fallback
        $extQuery = $Extension -join ';'
        $argExtensions = 'ext:{0}' -f $extQuery
        #>
        $queryExt = $Extension |  Join-String -sep ';' -op 'ext:'
        $queryDm = 'dm:{0}' -f 'today'
        $joinedQuery = $queryExt, $queryDm | Join-String -sep ' ' -op 'es:'

        br | Write-Information
        $queryExt, $queryDm | Label 'term' -fg orange
        | Write-Information

        Label 'Final Query' $joinedQuery
        if ($joinedQuery -notmatch '^es:') {
            'Failed syntax, prefix is not "es:"', $joinedQuery -join ' ' | Write-Error
            return
        }

        if ($WhatIf) {
            $joinedQuery
            return
        }

        Start-Process $joinedQuery

    }
}
#     process {
#     ) | Sort-Object -Unique
# }

# $argExtensions | Write-Debug


Invoke-EverythingSearch -Debug -WhatIf -InformationAction Continue
Invoke-EverythingSearch -Debug -InformationAction Continue
{
    h1 'or Everything.exe'
    $query = 'es:dm:{0} ext:{1}' -f @(
        'today'
        'pbix'
    )
    # Start-Process 'es:dm:today ext:pbix'
    Start-Process $query

    $parents | Join-String -Separator ', ' -SingleQuote
    | Label 'parents'

}