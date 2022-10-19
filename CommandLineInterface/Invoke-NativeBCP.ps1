# using Namespace System.Collections.Generic

<#
Note:
    everything should be PS5.1 compatible if you delete this attribute from parameters
    it is optional
        "ArgumentCompletions()"

#>

# Is this the right syntax?, if yes
# bcp prodcopy.dbo.vw_pt_mstr out C:\temp\vw_pt_mstr.txt -c -S localhost -T -t\t -r\n
function previewCommand {
    param( $CommandArgs )
    @(
        "`n"
        'bcp '
        $CommandArgs -join ' '
        "`n"
    ) -join ''
}

function Invoke-BcpStatic {
    <#
    .SYNOPSIS
        invoke a native command, hardcoded for simplicity
    #>

    # auto-exits early, prevents accidentally running weird commands if not found
    # this filters commands to executables only
    # this means if someone creates the alias 'bcp' it won't break your code
    $binBcp = Get-Command 'bcp' -CommandType Application -ea stop

    # these can be declared in one step
    # or many
    # and all on one line, or split up a bit for readability
    $bcpArgs = @(
        'prodcopy.dbo.vw_pt_mstr',
        'out',
        "C:\temp\vw_pt_mstr.txt",
        '-c', '-S', 'localhost',
        '-T', '-t\t', '-r\n'
    )
    previewCommand $bcpArgs
    return
}

function DoubleQuote {
    # Double quote values or filepaths
    # if the string is a valid path, resolve the full path
    <#
    .SYNOPSIS
        double quote raw strings or filepaths, required for proper shell
    .notes
        if a relative path string is valid, resolve the FullName before quote
    .EXAMPLE
        # test data
        New-Item 'C:\nin_temp\space paths\some status.log'
        pushd 'C:\nin_temp\space paths'

        # When files exist
        PS> Quote 'more spaced filepaths\current.log'
            Quote 'more spaced filepaths\current.log' -Raw

            "C:\nin_temp\space paths\more spaced filepaths\current.log"
            "more spaced filepaths\current.log"

    .EXAMPLE

        # When files do not exist
        PS> Quote 'fake filepath\does\not\exist.log'
            Quote 'fake filepath\does\not\exist.log'-Raw

            "fake filepath\does\not\exist.log"
            "fake filepath\does\not\exist.log"
    #>
    [Alias('QuoteIt')]
    [CmdletBinding()]
    param(
        # string, or File Item Info
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string]$Text,
        # Never convert to full path, only use the raw string
        [switch]$Raw)
    if((Test-path $Text) -and -not $raw) {
        '"{0}"' -f @( Get-Item $Text )
        return
    }
    '"{0}"' -f @( $Text )
}


function Invoke-Bcp {
    <#
    .SYNOPSIS
        invokes Bcp with user args
    .NOTES
    docs: <https://learn.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver16#c>

    for BCP docs, run:

        > BCP /?

    bcp.exe {dbtable | query} {in | out | queryout | format} datafile
        [-m maxerrors]            [-f formatfile]          [-e errfile]
        [-F firstrow]             [-L lastrow]             [-b batchsize]
        [-n native type]          [-c character type]      [-w wide character type]
        [-N keep non-text native] [-V file format version] [-q quoted identifier]
        [-C code page specifier]  [-t field terminator]    [-r row terminator]
        [-i inputfile]            [-o outfile]             [-a packetsize]
        [-S server name]          [-U username]            [-P password]
        [-T trusted connection]   [-v version]             [-R regional enable]
        [-k keep null values]     [-E keep identity values][-G Azure Active Directory Authentication]
        [-h "load hints"]         [-x generate xml format file]
        [-d database name]        [-K application intent]  [-l login timeout]
    .example
        Invoke-Bcp -Verbose -WhatIf -DTableOrQuery prodcopy.dbo.vw_pt_mstr -Mode out -DataFile C:\temp\vw_pt_mstr.txt -c '?' -ServerName localhost -TrustedConnection -t \t -RowTerminator \r
    .link
        https://learn.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver16#c

    #>
    [CmdletBinding()]
    param(
        # preview final command without executing
        [switch]$WhatIf,
        # or other info
        [switch]$Help,
        # The {dbtable | query} part of the Bcp query
        # with suggestions
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('prodcopy.dbo.vw_pt_mstr', 'devcopy.dbo.vw_pt_mstr')]
        [Parameter(Mandatory)][string]$DTableOrQuery,

        # target/source? the part of: {in | out | queryout | format}
        [ValidateSet('in', 'out', 'queryout', 'format')]
        [Parameter(Mandatory)]
        [string]$Mode,

        # fallbacks to a  to a temp path if not specified
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('C:\temp\vw_pt_mstr.txt')]
        [Parameter()][string]$DataFile = 'C:\temp\vw_pt_mstr.txt',

        [Alias('S')]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('localhost')]
        [Parameter()][string]$ServerName = 'localhost',

        # -T switch
        [Alias('Trust')]
        [Parameter()][switch]$TrustedConnection,

        # char type
        [Alias('c')]
        [switch]
        [Parameter()][switch]$CharType,

        # Field terminator -t
        [Alias('t')]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('\t', ',', ' ')]
        [Parameter()][string]$FieldTerminator = '\t',

        # row terminator -r
        [Alias('r')]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompletions('\r', '\n', '\r\n')]
        [Parameter()][string]$RowTerminator = '\r',

        [Alias('Args')]
        [string[]][Parameter(ValueFromRemainingArguments)]$RemainingArgs
    )

    # auto-exits early, prevents accidentally running weird commands if not found
    $binBcp = Get-Command 'bcp' -CommandType Application -ea stop
    if($Help) {
        & $binBcp @('/?')
        'see more: <https://learn.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver16#c>'
        return
    }

    # reference: bcp prodcopy.dbo.vw_pt_mstr out C:\temp\vw_pt_mstr.txt -c -S localhost -T -t\t -r\n

    $bcpArgs = @(
        $DTableOrQuery,
        $Mode
        QuoteIt $DataFile
        if($CharType) {
            '-c'
        }
        '-S', $ServerName
        if($TrustedConnection) {
            '-T'
        }

        # special args that can't have a space between them and the flags
        if($FieldTerminator) {
            '-t{0}' -f  @( $FieldTerminator )
        }
        if($RowTerminator) {
            '-r{0}' -f  @( $RowTerminator )
        }

        if($RemainingArgs.Count -gt 0) {
            $RemainingArgs
        }

    )
    # previewCommand $bcpArgs
    # 'bcp "{0}"' -f @(
    #     $DTableOrQuery
    # )
    if($WhatIf) {
        previewCommand $bcpArgs
        return
    }

    previewCommand $bcpArgs | Write-Verbose
    & $binBcp @BinArgs
    return

}

# validate output
# Invoke-Bcp -Verbose -WhatIf -DTableOrQuery prodcopy.dbo.vw_pt_mstr -Mode out -DataFile C:\temp\vw_pt_mstr.txt -c -ServerName localhost -TrustedConnection -t \t -RowTerminator \r |
#   Join-String |
#   Should -BeLike '*bcp prodcopy.dbo.vw_pt_mstr out "C:\temp\vw_pt_mstr.txt" -c -S localhost -T -c -t\t -r\r*'

if(Get-Module Pester -ea ignore) {
Invoke-Bcp -WhatIf -DTableOrQuery prodcopy.dbo.vw_pt_mstr -Mode out -DataFile C:\temp\vw_pt_mstr.txt -c -ServerName localhost -TrustedConnection -t \t -RowTerminator \r | Join-String
    | Should -beLike '*bcp prodcopy.dbo.vw_pt_mstr out "C:\temp\vw_pt_mstr.txt" -c -S localhost -T -t\t -r\r*' -Because 'manually crafted args example'
}