using namespace system.Collections.Generic
$counter = 1000000
$counter = 3000000
$counter = 6000000

[int[]]$sample = 1000, 50000, 1000000, 3000000, 6000000
$all ??= [list[object]]::new()

<#
> seeminglyscience: yeah it can sorta get away with boxing and unboxing a little less. Side note, make sure to put  Measure-Command 's body in a new scope like Measure-Command { & { } } otherwise the body is dot sourced which disables some compiler optimizations, that can greatly affect results
<https://discord.com/channels/180528040881815552/447476117629304853/811259269781389382>
#>

$sample | ForEach-Object {
    [int]$counter = $_
    Write-Host "Count: $Counter"
    $results = @(
        Write-Host 'Starting1...'
        Measure-Command {
            & {
                $list = [Collections.Generic.List[Object]]::new()
                for ($i = 0; $i -lt $counter; $i++) {
                    $list.Add($i)
                }
            }
        }

        Write-Host 'Starting2...'
        Measure-Command {
            & {
                $list = [Collections.Generic.List[int]]::new()
                for ($i = 0; $i -lt $counter; $i++) {
                    $list.Add($i)
                }
            }
        }
    )
    $results | Join-String TotalMilliseconds -FormatString '{0,20:n3} ms' -sep "`n" -op "$counter = `n"
    | Write-Information

    $deltaMs = $results[0].TotalMilliseconds - $results[1].TotalMilliseconds
    $all.Add(
        [pscustomobject]@{
            Delta_Ms     = $deltaMs.tostring('f3')
            Counter      = [int]$counter
            | ForEach-Object tostring 'n'
            Results      = $results
            ResultString = $results | Join-String TotalMilliseconds -sep ', '  #-FormatString '{0:n0}' -sep ', '
            Positive     = ($deltaMs -gt 0) ? 'Yes' : ''
        }
    )
}

$all | Format-Table Delta_Ms, Counter, ResultString
$all | Format-Table Delta_Ms, Counter, ResultString -GroupBy Counter
