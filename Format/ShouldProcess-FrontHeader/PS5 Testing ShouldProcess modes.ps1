
$TargetName = [string](New-Text 'Target' -fore red)
$OperationName = [string](New-Text 'Operation' -fore blue)
$MessageString = [string](New-Text 'Message' -fore green)

$TestAll = $true # toggle testing every possibility
$ItemLimit = 1
function h1 { "`n`n#### $args  `n`n" }
function label { param($a, $b) "$a : $b" }


function toCsv {
    # Normally I recommend not using '$Input', because there's so many edge
    # cases and quirks, but in this case it's okay
    $Input | Join-String -sep ', '
}
function toList {
    $Input | Join-String -sep "`n- " -op "`n- "
}

Write-Warning 'very old code, :P'
function Test-ShouldProcessReason {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    param (
        [Parameter(Position = 0)]
        [ArgumentCompletions(0, 1, 2, 3, 4, 5)]
        # [ValidateRange(1, 4)]
        [int]$ArgCount = 3
    )

    $SampleNames = 'dog.png', 'cat.jpg', 'reptile.png'
    $InputNames = $SampleNames | Select-Object -First $ItemLimit
    switch ($ArgCount) {
        # 1 {
        #     "$ArgCount = `$TargetName"
        #     if ($PSCmdlet.ShouldProcess( $TargetName )) {
        #         "Execute item: $TargetName"
        #         $InputNames | ForEach-Object { "Item: $_" }
        #     }
        #     break
        # }
        # 2 {
        #     "$ArgCount = `$TargetName, `$OperationName"
        #     if ($PSCmdlet.ShouldProcess( $TargetName , $OperationName)) {

        #         # "Execute item: $TargetName, $OperationName"
        #         $InputNames | ForEach-Object { "Item: $_" }
        #     }
        #     break
        # }
        1 {
            # copy of 1
            H1 "$ArgCount = `$TargetName"
            ''
            $InputNames | ForEach-Object {
                $CurItem = $_
                "Item: $CurItem" | Write-Debug
                if ($PSCmdlet.ShouldProcess( $TargetName )) {
                    "`nItem: $CurItem"
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Verbose
                }
            }
            break
        }
        2 {
            # copy of 2
            H1 "$ArgCount = `$TargetName, `$OperationName"
            ''
            $InputNames | ForEach-Object {
                $CurItem = $_
                "Item: $CurItem" | Write-Debug
                if ($PSCmdlet.ShouldProcess( $TargetName , $OperationName)) {
                    "`nItem: $CurItem"
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Verbose
                }
            }
            break
        }
        # 3 {
        #     "$ArgCount = `$MessageString `$TargetName, `$OperationName"
        #     if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName)) {
        #         # "Execute item: $MessageString, $TargetName, $OperationName"
        #         $InputNames | ForEach-Object { "Item: $_" }
        #     }
        #     break
        # }

        3 {
            # copy of 3
            H1 "$ArgCount = `$MessageString `$TargetName, `$OperationName"
            ''
            $InputNames | ForEach-Object {
                $CurItem = $_
                "Item: $CurItem" | Write-Debug
                if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName)) {
                    "`nItem: $CurItem"
                    "Execute item: $MessageString, $TargetName, $OperationName" | Write-Verbose
                }
            }
            break
        }

        4 {
            $Reason = [System.Management.Automation.ShouldProcessReason]::WhatIf
            "$ArgCount = `$MessageString `$TargetName, `$OperationName, [ref]`$Reason"
            if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName, [ref]$reason)) {
                # "Execute Item: `$MessageString `$TargetName, `$OperationName, [ref]`$Reason"
                $InputNames | ForEach-Object { "Item: $_" }
            }
            break
        }
        5 {
            # $Reason = [System.Management.Automation.ShouldProcessReason]::WhatIf
            $Reason = [System.Management.Automation.ShouldProcessReason]::None
            "$ArgCount = `$MessageString `$TargetName, `$OperationName, [ref]`$Reason"
            if ($PSCmdlet.ShouldProcess($MessageString, $TargetName , $OperationName, [ref]$reason)) {
                # "Execute Item: `$MessageString `$TargetName, `$OperationName, [ref]`$Reason"
                $InputNames | ForEach-Object { "Item: $_" }
            }
            break
        }
        default { throw 'ShouldNeverReachException' }

    }

}
"`n`n"
$ItemLimit = 3
if ($true -and $TestAll) {
    1..4 | ForEach-Object {
        Test-ShouldProcessReason $_
        "`n`n"
    }
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
