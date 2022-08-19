
function Foo3 {
    process {
        # Write-Warning "processing file: '$Input'"
        return [pscustomobject]@{
            Size    = $Input.Length
            SizeKb  = $Input.Length / 1kb
            Name    = $Input.Name
            IsAFile = $Input -is 'IO.FIleInfo'
            AsFile  = $Input -as 'IO.FileInfo'
            IsNull  = $Null -eq $Input
        }
    }
}

#works
@(
    Get-Item .\Case1-part1.ps1
    'Case1-part1.ps1'
) | Foo3 | Format-Table
# fails
# (Get-Item .\Case1-part1.ps1 | ForEach-Object Name) | Foo3
