function Case_SelectFiles2 {
    <#
    .synopsis
        example $input
    #>
    [CmdletBinding()]
    param()
    begin {
        [object[]]$OnlyFiles = @()
        [object[]]$Others = @()
    }
    process {
        if ($Input -is 'IO.FileInfo') {
            $OnlyFiles += $Input
        } else {
            $Others += $Input
        }
    }
    end {
        $OnlyFiles.count | Join-String -op 'Files: '
        $Others.Count | Join-String -op 'others: '
    }
}

Get-ChildItem . | Case_SelectFiles2
