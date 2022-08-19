#Requires -Module benchpress

Measure-Benchmark -Technique @{
    'SortedSet' = {
        # $a = 1..10000 | ForEach-Object { ([char]$_).ToString() }
        # $b = 1..10000 | ForEach-Object { if ($_ -eq 5) { 'different' } else { ([char] $_).ToString() } }
        0..100

        # [Collections.Generic.SortedSet[String]]::CreateSetComparer().Equals($a, $b)
    }
    'HashSet'   = {
        0..100
        # $a = 1..10000 | ForEach-Object { ([char]$_).ToString() }
        # $b = 1..10000 | ForEach-Object { if ($_ -eq 5) { 'different' } else { ([char]$_).ToString() } }
        # [Collections.Generic.HashSet[String]]::CreateSetComparer().Equals($a, $b)

    }
} -RepeatCount 3 -Detailed