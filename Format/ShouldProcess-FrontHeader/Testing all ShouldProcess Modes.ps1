#Requires -Version 7

. (Get-Item -ea stop (Join-Path $PSScriptRoot './ShouldProcess.Utils.ps1')) | Out-Null

<# Future: strip colors if $ENV:NO_COLOR has any valey #>

$Color = @{
    TargetName    = Fg '#c87c4f'   # red-ish
    OperationName = Fg '#6eabdd'   # blue-ish
    MessageText   = Fg '#4cd189' # tan-ish
    ItemText      = Fg '#d362a2'  # '
    BGTeal        = Bg '#2d6f68'
    FGBright      = Fg '#c9e3e3'
    WarningYellow = Fg '#f4f429'
    Reset         = $PSStyle.Reset
}

$TestAll = $true # toggle testing every possibility
$ItemLimit = 2

@'

Note:
    - use {0}for additional output
    - this is a wip -- I know it's messy


try:

    Test-ShouldProcessReason 4
    Test-ShouldProcessReason 4 -Infa Continue
'@ -f @(
    $COlor.BGTeal, '-Infa Continue ' , $Color.WarningYellow -join ''

) | Write-Warning

function Test-ShouldProcessReason {
    <#
    .synopsis
        visually test many variations of function invokes
    .notes
        WhatIf, and ShouldContinue greatly vary depending on which host
        you are using ( that's why I w wrote this )

        future:
            - [ ] pipe opjects for multi-confirm prompts
            - [ ] Disable color if $ENV:NO_COLOR has any value
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    param (

        # Choose which mode to test
        # [ValidateRange(1, 4)]
        [Parameter(Position = 0)]
        [ArgumentCompletions(0, 1, 2, 3, 4, 5)]
        [int]$OutputFormat = 3
    )

    $SampleNames = 'dog.png', 'cat.jpg', 'reptile.png'
    $InputNames = $SampleNames | Select-Object -First $ItemLimit
    $TargetName = wrapFg 'Some Target' $Color.TargetName
    $OperationName = wrapFg 'Operation' $Color.OperationName
    $MessageString = wrapFg 'Message' $Color.MessageText
    $ItemString = wrapFg "Item: $CurItem" $Color.ItemText
    $InvokeString = @(
        $Color.FGBright, $Color.BGTeal -join ''
    )

    NL 4


    switch ($OutputFormat) {
        1 {
            H1 "OutFormat: '$OutputFormat' , Target: '$TargetName'"
            | Write-Information

            $InputNames | ForEach-Object {
                $CurItem = $_

                # wrapFg "Item: $CurItem" $Color.ItemText
                @'

Invocation:
    $PSCmdlet.ShouldProcess( $TargetName )

'@
                | Join-String -op $Color.BGTeal -os $Color.Reset
                | Write-Information

                if ($PSCmdlet.ShouldProcess( $TargetName )) {
                    @(
                        NL 2
                        "Invoke 🚀${ItemString} ${curItem} => {$TargetName}"
                    ) -join ''
                    # ${ItemString}: $CurItem"
                    # # "Execute item: $MessageString, $TargetName, $OperationName" | Write-Verbose
                }
            }
            break
        }
        default {
            throw "ShouldNeverReachException: Mode = '$OutputFormat'"
        }
        4 {

            @'

Invocation:
    $PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName, [ref]$reason)
        with [ShouldProcessReason]::WhatIf

'@
            | Join-String -op $Color.BGTeal -os $Color.Reset
            | Write-Information


            $Reason = [System.Management.Automation.ShouldProcessReason]::WhatIf

            $InputNames | ForEach-Object {



                "${ItemString}: $_ ?"
                if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName, [ref]$reason)) {
                    @(
                        # NL 2
                        # "Invoke 🚀${ItemString} ${curItem} => {$TargetName}"
                        "Invoke 🚀${ItemString} ${curItem} => Op: $OperationName => {$TargetName}"
                        "`n`t"
                        "Message: ${MessageString}"
                    ) -join ''
                }
            }

            break
        }
        5 {
            @'

Invocation:
    $PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName, [ref]$reason)
        with [ShouldProcessReason]::None

'@
            | Join-String -op $Color.BGTeal -os $Color.Reset
            | Write-Information

            # $Reason = [System.Management.Automation.ShouldProcessReason]::WhatIf
            $Reason = [System.Management.Automation.ShouldProcessReason]::None
            if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName, [ref]$reason)) {
                # "Execute Item: `$MessageString `$TargetName, `$OperationName, [ref]`$Reason"
                $InputNames | ForEach-Object {
                    $curItem = $_
                    @(
                        NL 2
                        "Invoke 🚀${ItemString} ${curItem} => Op: $OperationName => {$TargetName}"
                        "`n`t"
                        "Message: ${MessageString}"

                    ) -join ''
                }
            }
            break
        }
        # 1 {
        #     "$OutputFormat = `$TargetName"
        #     if ($PSCmdlet.ShouldProcess( $TargetName )) {
        #         "Execute item: $TargetName"
        #         $InputNames | ForEach-Object { "Item: $_" }
        #     }
        #     break
        # }
        # 2 {
        #     "$OutputFormat = `$TargetName, `$OperationName"
        #     if ($PSCmdlet.ShouldProcess( $TargetName , $OperationName)) {

        #         # "Execute item: $TargetName, $OperationName"
        #         $InputNames | ForEach-Object { "Item: $_" }
        #     }
        #     break
        # }

        2 {
            # copy of 2
            # H1 "$OutputFormat = `$TargetName, `$OperationName"
            # ''
            $InputNames | ForEach-Object {
                $CurItem = $_
                "Item: $CurItem" | Write-Debug
                if ($PSCmdlet.ShouldProcess( $TargetName , $OperationName)) {
                    "`nItem: $CurItem"
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Verbose
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Information
                }
            }
            break
        }
        # 3 {
        #     "$OutputFormat = `$MessageString `$TargetName, `$OperationName"
        #     if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName)) {
        #         # "Execute item: $MessageString, $TargetName, $OperationName"
        #         $InputNames | ForEach-Object { "Item: $_" }
        #     }
        #     break
        # }

        3 {
            # copy of 3
            H1 "$OutputFormat = `$MessageString `$TargetName, `$OperationName"
            ''
            $InputNames | ForEach-Object {
                $CurItem = $_
                "Item: $CurItem" | Write-Debug
                if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName)) {
                    "`nItem: $CurItem"
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Verbose
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Information
                }
            }
            break
        }

    }
    $PSStyle.Reset

}
return
Test-ShouldProcessReason 5
return
if ($TestAll) {
    1..5 | ForEach-Object {
        Test-ShouldProcessReason $_
        "`n`n"
    }

    # Test-ShouldProcessReason -OutputFormat 3
    # Test-ShouldProcessReason -OutputFormat 4

    # return

    # $ItemLimit = 3
} else {
    hr
    Test-ShouldProcessReason 7 # -Verbose
    break
    # Test-ShouldProcessReason 3
    hr 2
    Test-ShouldProcessReason 5  #-Verbose
    hr 2
    Test-ShouldProcessReason 6 # -Verbose
}

# Write-Warning 'this code is to visualize **for**blog post'
