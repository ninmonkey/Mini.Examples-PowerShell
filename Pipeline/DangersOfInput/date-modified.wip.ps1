
function modifiedToday {
    process {
        $today = (Get-Date).AddDays(-1)
        if ($input -is 'string') {
            Write-Warning 'str'
        } else {
            Write-Warning 'ok'
        }
        $input.Name, $input.Length
        $input | Where-Object { $_ -is 'IO.FileInfo' } | ForEach-Object { $_.Name, $_.Length }
    }
}

#works
(Get-Item .\Case1-part1.ps1) | modifiedToday
# fails
(Get-Item .\Case1-part1.ps1 | ForEach-Object Name) | modifiedToday

Hr -fg magenta

function foo2 {
    process {
        # Write-Warning "processing file: '$Input'"
        return [pscustomobject]@{
            IsAFile = $Input -is 'IO.FIleInfo'
            Name    = $Input.Name
            AsFile  = $Input -as 'IO.FileInfo'
            Size    = $Input.Length
        }
        #     $today = (Get-Date).AddDays(-1)
        #     if ($input -is 'string') {
        #         Write-Warning 'str'
        #     } else {
        #         Write-Warning 'ok'
        #     }
        #     $input.Name, $input.Length
        #     $input | Where-Object { $_ -is 'IO.FileInfo' } | ForEach-Object { $_.Name, $_.Length }
        # }
    }
}

#works
(Get-Item .\Case1-part1.ps1) | foo2
# fails
(Get-Item .\Case1-part1.ps1 | ForEach-Object Name) | foo2
