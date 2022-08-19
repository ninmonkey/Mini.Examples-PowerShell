
function Foo5_ArrayForgiveMe {
    begin {
        [object[]]$files = @()
        [object[]]$all = @()
    }
    process {
        if ($Input -is 'IO.FIleInfo') {
            $files += $Input
        }
        $all += $Input
    }
    end {
        # Write-Warning "processing file: '$Input'"
        return @{
            Files = $files
            All   = $All
        }
    }
}

#works
$res = @(
    Get-Item .\Case1-part1.ps1
    'Case1-part1.ps1'
) | Foo5

$res | Format-Table

function Foo6_List {
    begin {
        $Files = [list[object]]::new()
        $All = [list[object]]::new()
    }
    process {
        if ($Input -is 'IO.FIleInfo') {
            $files.Add( $Input )
        }
        $all.Add( $Input )
    }
    end {
        # Write-Warning "processing file: '$Input'"
        return [psCustomobject]@{
            Files = $files
            All   = $All
        }
    }
}

function Foo7_Simplified {
    begin {
        $items = [list[object]]::new()
    }
    process {
        $items.Add( $Input )
    }
    end {
        return $items
    }
}

#works
$res = @(
    Get-Item .\Case1-part1.ps1
    'Case1-part1.ps1'
) | Foo6_List

$res | Format-Table

Hr
#works
$res7 = @(
    Get-Item .\Case1-part1.ps1
    'Case1-part1.ps1'
) | Foo7_Simplified

$res7 | Format-Table
return
# function Foo4 {
#     process {
#         # Write-Warning "processing file: '$Input'"
#         return [pscustomobject]@{
#             Size      = $Input.Length
#             SizeKb    = $Input.Length / 1kb
#             Name      = $Input.Name
#             IsAFile   = $Input -is 'IO.FIleInfo'
#             AsFile    = $Input -as 'IO.FileInfo'
#             IsNull    = $Null -eq $Input
#             TypeNames = $Input.PSTypeNames
#         }
#     }
# }

# #works
# $res = @(
#     Get-Item .\Case1-part1.ps1
#     'Case1-part1.ps1'
# ) | Foo4

# $res | Format-Table
