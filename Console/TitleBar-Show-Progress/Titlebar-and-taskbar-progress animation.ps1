function Set-ProgressIndicator {
    <#
    .notes
        From: <https://github.com/JustinGrote>
    .example
    PS> 
        "Starting!"
        1..100 |% {Set-ProgressIndicator $_;sleep 0.1}
        "Done"
        Set-ProgressIndicator -Reset
    #>
    param(
        [ValidateRange(0, 100)][int]$Percentage = 0,
        [Switch]$Paused,
        [Switch]$Reset,
        [Switch]$Indeterminate,
        [Switch]$Errored
    )
        
    $state = switch ($true) {
        $Reset {
            0; break
        }
        $Errored {
            2; break
        }
        $Indeterminate {
            3; break
        }
        $Paused {
            4; break
        }
        default {
            1; break
        }
    }

    $beginSequence = "`e]9;4"
    $endSequence = "`e\"
    [console]::Write("$beginSequence;$state;$Percentage;$endSequence")
}

