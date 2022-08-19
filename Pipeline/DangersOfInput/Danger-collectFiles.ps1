function dangerTest1 {
    # Get a list of files, ignore folders
    begin {
        $Files = @()
        $ExpectCount = 0
    }
    process {
        if ($Input -is 'IO.FileInfo') {
            $Files += $Input
            $ExpectCount++
        }
        $ExpectCount++
    }
    end {
        $Files.count | Join-String -op 'Found file: '
        $ExpectCount | Join-String -op 'Expect Count: '
    }
}
cls
(Get-ChildItem . -File).count | Join-String -op 'File count: '

# the exact same condition
(Get-ChildItem . -File
| Where-Object { $_ -is 'IO.FileInfo' } ).count
| Join-String -op 'Count using Operator "-is": '


# If File count is 3, what will this return ?
Get-ChildItem . | dangerTest1

<#
output:

    File count: 4
    Count using Operator "-is": 4
    Found file: 0
    Expect Count: 4
#>
