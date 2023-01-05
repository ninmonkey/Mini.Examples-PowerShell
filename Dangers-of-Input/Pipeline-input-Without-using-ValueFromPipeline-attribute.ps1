Write-Warning "discord ping to 'mazawa' when done"

# The only requirement for `$Input` is that you have a `-Process` block

function doubleIt {
    # minimum reuuirement to use $Input
    process {
        $Input * 2
    }
}
<#
    4, 'cat', 34 | doubleIt

4
4
cat
cat
34
34
#>

function Get-TypeInfo {
    <#
    .synopsis
    #>
    # first example outputs what you'd expect
    param()
    process {
        foreach ($item in $Input) {
            if ($item -is 'IO.FileSystemInfo') {
                "File: $($item.FullName)"
            }
        }
        if ($Input -is 'string') {
        }
        $saved = $Input | ForEach-Object { $_ }
        foreach ($Item in $Saved) {
            $item.GetType().FullName
        }

        foreach ($Item in $saved) {
            $item.GetType().FullName | Write-Error
        }

    }
}

(Get-Item .), 'test', 456 | Get-TypeInfo -ea continue


function example1 {
    <#
    .synopsis
        minimal function showing $Input
    #>
    param()
    process {

    }
}
