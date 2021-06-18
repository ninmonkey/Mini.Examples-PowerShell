

function IntToAnsi {
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = 'int of a 4-bit ansi color')]
        [int]$ColorNumber
        # [switch]$NoClose = $true
    )
    <#
    .description
        converts int to 4-bit color ANSI escape
    .example
        PS> IntToAnsi 34

    .example
        PS> 30..50 | %{
            (IntToAnsi $_), $_, ' color', (IntToAnsi 0),  '.' -join ''
        }
    #>
    if (! $ColorNumber -is 'int') {
        "Invalid ansi value: '$ColorNum'" | Write-Warning
    }
    "`e[{0}m" -f $ColorNumber
}

if ($false -and $run_test) {

    Test-AnsiColors -PassThru
    | Tee-Object -Variable 'teeAnsi'
    | Join-String -Separator "z`nz" -Property Text -OutputPrefix 'z' -OutputSuffix 'z'
    | Tee-Object -Variable 'teeString'

}

function AnsiColorGlobals {

    $color4Bit = @{
        Gray     = "`e[37m"
        DarkGray = "`e[90m"
        Reset    = "`e[0m"
    }

    $color4Bit = @{
        default = $colorConsole.gray
    }

    $color = @{

    }
    $themeNord = @{
        BlueText       = 129, 161, 193
        DarkBackground = 46, 52, 64
        Background     = 59, 66, 82
        GreenText      = 163, 190, 128
        OrangeText     = 235, 203, 120
        TealText       = 136, 192, 208
        WhiteTexxt     = 205, 222, 233
    }

    $themeCurWinTerm = @{
        WhiteText       = 204, 204, 204 # default WhiteTextForeground
        BrightWhiteText = 242, 242, 242
        GrayText        = 118, 118, 118
        YellowText      = 249, 241, 165
        GreenText       = 19, 161, 14
        BlueText        = 50, 127, 186
        RedText         = 231, 72, 86 # not bold
        BrightGreenText = 22, 198, 12
        CyanText        = 231, 72, 86
    }
    $themeCurWinTerm['DefaultText'] = $themeCurWinTerm['WhiteText']
    Write-Warning 'refactor'
}

function Test-AnsiColors {
    <#
    .notes
        this is messy, doesn't make sense to pipe currently as the data itself is padded

        see: https://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit
    .example
        PS> Test-AnsiColors | Format-Wide -AutoSize
    .example
        PS> Test-AnsiColors -Mode Ansi-4bit
    .example
        PS> Test-AnsiColors -Mode 'enum ConsoleColor'

    #>
    param(

        [uint]$start = 0,

        [uint]$stop = 127,

        [uint[]]$sequence = @(),

        [switch]$PassThru,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Ansi-4bit', 'enum ConsoleColor')]
        [String]$Mode = $null #$[string]::empty
    )
    $AnsiColor = @{
        # Green = "`e[32m"
        # Blue  = "`e[36m"
        Reset = "`e[0m"
    }

    # h1 'Ansi range'
    if ($sequence.Count -gt 0) {
        $colorRange = $sequence
    }
    else {
        $colorRange = $start..$stop
    }
    if ($Mode -eq 'Ansi-4bit') {
        <#
            todo: why does calling
                Test-AnsiColors -PassThru -sequence (30..37 + 39 + 40..47 + 49 + 90..97 + 100..107) | Ft Text
            skip values 30, 90, 100 ?
        #>
        $colorRange = 30..37 + 39 + 40..47 + 49 + 90..97 + 100..107
    }
    $colorRange -join ', ' | Write-Verbose

    if ($Mode -eq 'enum ConsoleColor') {
        h1 'Enum: [System.ConsoleColor]'
        [enum]::GetNames( [System.ConsoleColor] ) | ForEach-Object {
            Write-Host -ForegroundColor $_ $_
        }
        return
    }
    # else {
    #     $colorRange = @(7..12) + @(97..104)
    # }

    $colorList = $colorRange | ForEach-Object {
        [int]$Number = $_
        $Group = 0
        $meta = [ordered]@{
            Number = $Number
            Group  = $Number
            Text   = '|{0,5} {1}{2}{3}.|' -f @(
                (
                    # '{0,-8:d}' -f $Number
                    $Number.ToString('d')
                )
                (IntToAnsi $Number),
                'Text',
                $AnsiColor.Reset
            )
        }
        $Number ++

        [pscustomobject]$meta
    }
    if ($PassThru) {
        $colorList
    }
    else {
        $colorList | Format-Wide -AutoSize -Property Text
    }
}

# Test-AnsiColors
if ($false -and $run_test) {
    Test-AnsiColors -PassThru  | Format-Wide -AutoSize Text
}
