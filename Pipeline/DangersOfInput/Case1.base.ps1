function Case_SelectFiles_min {
    # variation using param()
    [CmdletBinding()]
    param()
    begin {
        $Files = @()
    }
    process {
        if ($Input -is 'IO.FileInfo') {
            $Files += $Input
        }
    }
    end {
        $Files.count | Join-String -op 'Found Files: '
    }
}

(Get-ChildItem . -File).count | Join-String -op 'File count: '

# If File count is 3, what will this return ?
Get-ChildItem . | Case_SelectFiles_min

function Case_SelectFiles_min2 {
    # variation no param()
    begin {
        $Files = @()
        $ExpectCount = 0
    }
    process {
        if ($Input -is 'IO.FileInfo') {
            $Files += $Input
            $ExpectCount++
        }
    }
    end {
        $Files.count | Join-String -op 'Found file: '
        $ExpectCount | Join-String -op 'Expect Count: '
    }
}



(Get-ChildItem . -File).count | Join-String -op 'File count: '

# the exact same test
(Get-ChildItem . -File
| Where-Object { $_ -is 'IO.FileInfo' } ).count
| Join-String -op 'File count using "-is": '


# If File count is 3, what will this return ?
Get-ChildItem . | Case_SelectFiles_min2
