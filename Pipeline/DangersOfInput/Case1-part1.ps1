
function Case_SelectFiles1 {
    <#
    .synopsis
        example $input
    #>
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
        # $all.Add( $Input )
    }
    end {
        $OnlyFiles.count | label 'Files'
        $Others.Count | label 'others'
    }
}

Get-ChildItem . | Case_SelectFiles1
