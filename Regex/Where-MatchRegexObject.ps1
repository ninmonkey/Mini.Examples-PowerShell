# // see: Ninmonkey.Console\?Str

function Where-MatchRegexObject {
    <#
    .synopsis
        simplify matching regex in the pipeline
    .description
       This is for cases where you had to use
            ... | ?{ $_ -match $regex } | ...
        or
            ... | ?{ $_.Name -match $regex } | ...

        Function allows you to use raw-text matching on properties, without converting
        the pipeline to raw text.

    .notes
        .
    .example
        # the regex for this example is just 'json'
        # It's able to be that simple because of -Start/-Ends
        # using -starts which is more natural
        # using property 'Name' instead of 'FullName'
        🐒> ls ~ -Directory -Depth 2 # normally returns 2,033 files
        | ?str .vscode -Starts Name

    .example
        🐒> ls ~ | ?str json -Ends
    .example
        🐒> gi fg:\red | iprop $c | % Name | ?str -not 'ps' -begin
    .example
        🐒> ls ~ -Force
        | ?str 'vscode'

            Directory:C:\Users\cppmo_000

            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁   11/21/2019   8:26 PM        .vscode
            📁   11/21/2020   9:46 AM        .vscode-insiders
    .example
        # This time only on a specific property, the name.

        🐒> ls $Env:APPDATA
        | ?Str code Name

            Directory:C:\Users\cppmo_000\AppData\Roaming


            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁    8/30/2021   2:58 PM        Code
            📁    8/30/2021   7:44 PM        Code - Insiders
            📁   12/14/2020   5:14 PM        ICSharpCode
            📁    2/16/2019   4:46 PM        Visual Studio Code
            📁   12/12/2020   6:27 PM        vscode-mssql

    .example
        # full match still allows wildcards

        🐒> ls $Env:APPDATA | ?Str code.* Name -FullMatch

            Directory:C:\Users\cppmo_000\AppData\Roaming


            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁    8/30/2021   2:58 PM        Code
            📁    8/30/2021   7:44 PM        Code - Insiders
    .example
        # Now only find fullmatches

            C: ▸ Users ▸ cppmo_000 ▸ Documents ▸ 2021 ▸ Powershell
            🐒> ls $Env:APPDATA | ?Str code Name -FullMatch

                    Directory:C:\Users\cppmo_000\AppData\Roaming


            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁    8/30/2021   2:58 PM        Code

    .outputs
          [object] as passed in

    #>
    [alias( '?Str', 'MatchStr', 'Where-String')]
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = '__AllParameterSets')]
    param(
        # Parametertype: Use a [object] so it can write warnings when a non-string type maybe accidentally was used?
        #   array or not? that can change how patterns will match
        #   when there's only access to one line
        <# (copied 'Format-ControlChar')
        format unicode strings, making them safe.
            Null is allowed for the user's conveinence.
            allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
        #>
        [alias('Text', 'Lines')]
        [Parameter(
            # ParameterSetName = 'MatchRawString',
            Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [object]$InputObject,

        # Match regex
        [Alias('Regex', 'Pattern')]
        [AllowEmptyString()]
        [Parameter(
            # ParameterSetName = 'MatchRawString',
            Mandatory, Position = 0)]
        [string]$MatchPattern,

        # Filter on properties instead of raw string
        [Parameter(Mandatory, ParameterSetName = 'MatchOnProperty', Position = 1)]
        [string]$Property,

        # Both ends must match. This is equivalent to using both -Begins and -Ends
        [Parameter()][switch]$FullMatch,

        # Pattern beginning must match. It adds '^' to the start of the pattern
        [alias('Starts')]
        [Parameter()][switch]$Begins,

        # Pattern ending must match. It adds '$' to the end of the pattern
        # You can still use patterns like 'dog.*' -Ends
        # to get 'dog.*$'
        [Alias('Stops')]
        [Parameter()][switch]$Ends
    )
    begin {
        $MatchPattern = @(
            ($Begins -or $FullMatch) ? '^' : $null
            $MatchPattern
            ($Ends -or $FullMatch) ? '$' : $null
        ) | Join-String

        $PSBoundParameters | Format-Table | Out-String | Write-Verbose
    }
    process {
        try {
            $InputObject
            | Where-Object {
                switch ($PSCmdlet.ParameterSetName) {
                    'MatchOnProperty' {
                        Write-Debug "Match on Property '$Property'"
                        if ($InputObject.$Property -match $MatchPattern) {
                            $true
                            return
                        }
                        else {
                            $false
                            return
                        }
                    }
                    default {
                        Write-Debug "Match on Text '$InputObject'"
                        if ($InputObject -match $MatchPattern) {
                            $true
                            return
                        }
                        else {
                            $false
                            return
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
    end {
        # I think null values enumerated will work?

    }
}
