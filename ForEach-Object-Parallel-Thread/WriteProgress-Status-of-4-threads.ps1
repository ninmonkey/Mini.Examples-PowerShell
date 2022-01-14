#Requires -Version 7.0.0

Get-Item -ea ignore (Join-Path $PSScriptRoot 'Readme.md') | Show-Markdown
| Out-Null

function WriteProgressTest {
    param(
        # num input data
        [Parameter()][int]$NumRecords = 5,
        [Parameter()][int]$SleepMod = 1,
        # for -ThrottleLimit
        [ALias('ThrottleLimit')]
        [Parameter()][int]$NumThreads = 3
    )
    process {
        # Example workload
        $dataset = @(
            @{
                Id   = 1
                Wait = 3..10 | Get-Random | ForEach-Object { $_ * $SleepMod }
            }
            @{
                Id   = 2
                Wait = 3..10 | Get-Random | ForEach-Object { $_ * $SleepMod }
            }
            @{
                Id   = 3
                Wait = 3..10 | Get-Random | ForEach-Object { $_ * $SleepMod }
            }
            @{
                Id   = 4
                Wait = 3..10 | Get-Random | ForEach-Object { $_ * $SleepMod }
            }
            @{
                Id   = 5
                Wait = 3..10 | Get-Random | ForEach-Object { $_ * $SleepMod }
            }
        ) | Select-Object -First $NumRecords
        # $dataset | Format-Dict
        # $PSBoundParameters | Format-Table | Write-Host

        # Create a hashtable for process.
        # Keys should be ID's of the processes
        $origin = @{}
        $dataset | ForEach-Object { $origin.($_.id) = @{} }

        # Create synced hashtable
        $sync = [System.Collections.Hashtable]::Synchronized($origin)

        $job = $dataset | ForEach-Object -ThrottleLimit 3 -AsJob -Parallel {
            $syncCopy = $using:sync
            $process = $syncCopy.$($PSItem.Id)

            $process.Id = $PSItem.Id
            $process.Activity = "Id $($PSItem.Id) starting"
            $process.Status = 'Processing'

            # Fake workload start up that takes x amount of time to complete
            Start-Sleep -Milliseconds ($PSItem.wait)

            # Process. update activity
            $process.Activity = "Id $($PSItem.id) processing"
            foreach ($percent in 1..100) {
                # Update process on status
                $process.Status = "Handling $percent/100"
                $process.PercentComplete = (($percent / 100) * 100)

                # Fake workload that takes x amount of time to complete
                Start-Sleep -Milliseconds $PSItem.Wait
            }

            # Mark process as completed
            $process.Completed = $true
        }

        while ($job.State -eq 'Running') {
            $sync.Keys | ForEach-Object {
                # If key is not defined, ignore
                if (![string]::IsNullOrEmpty($sync.$_.keys)) {
                    # Create parameter hashtable to splat
                    $param = $sync.$_

                    # Execute Write-Progress
                    Write-Progress @param
                }
            }

            # Wait to refresh to not overload gui
            Start-Sleep -Seconds 0.1
        }
    }
}

WriteProgressTest
