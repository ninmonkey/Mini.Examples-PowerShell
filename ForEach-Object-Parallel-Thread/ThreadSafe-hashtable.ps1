$Docs = @'

# About Foreach-Object -Parallel

Source based on: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.2#example-14--using-thread-safe-variable-references

Example output:
```ps1
NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     82    82.87     130.85      15.55    2808   2 pwsh
```
'@

function usingParallel {
    $threadSafeDictionary = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
    Get-Process | ForEach-Object -Parallel -ThrottleLimit 99 {
        $dict = $using:threadSafeDictionary
        $dict.TryAdd($_.ProcessName, $_)
    }
    $threadSafeDictionary.Values
}

function withoutParallel {
    $notThreadSafeDict = @{}

    Get-Process | ForEach-Object {
        if (! ($notThreadSafeDict.ContainsKey($_.ProcessName)) ) {
            return
        }
        $notThreadSafeDict.Add( $_.ProcessName, $_ )
    }
    $notThreadSafeDict.Values
    # $notThreadSafeDict['pwsh']
}

$Results = @{}
# $Results.usingParallel += @(
#     Measure-Command { & {
#             usingParallel
#             #| out-default
#         } } | ForEach-Object TotalMilliseconds
# )

# $Results.withoutParallel = @(
#     Measure-Command { & {
#             withoutParallel
#             #| out-default
#         } } | ForEach-Object TotalMilliseconds
#     | ForEach-Object {
#         [pscustomobject]@{
#             Name    = 'without'
#             TotalMS = $_
#         }
#     }
# )
$Results.usingParallel = @(
    Measure-Command { & {
            usingParallel
            #| out-default
        } } | ForEach-Object TotalMilliseconds
    | ForEach-Object {
        $_
    }
)
$Results.withoutParallel = @(
    Measure-Command { & {
            withoutParallel
            #| out-default
        } } | ForEach-Object TotalMilliseconds
    | ForEach-Object {
        $_
    }
)

# $Results.usingParallel
# $Results.withoutParallel
$results

hr 2
$docs | Show-Markdown
