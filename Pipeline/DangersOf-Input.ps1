using namespace System.Collections.Generic

function Case_SelectFiles1 {
    <#
    .synopsis
        fails to get right values
    #>
    # [CmdletBinding()]
    # param()

    begin {
        # $files = [List[object]]::new()
        # $all = [list[object]]::new()
        [object[]]$OnlyFiles = @()
        [object[]]$Others = @()
    }
    process {
        if ($Input -as 'IO.FileInfo') {
            # $files.Add( $Input )
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

(Get-ChildItem . -File).count | Label 'Input File Count'

$results = (Get-ChildItem . -File)
| Case_SelectFiles
$results

return

function try1 {
    $Input | Join-String -sep ', ' -SingleQuote
}

function try2 {
    end {
        $Input | Join-String -sep ', ' -SingleQuote
    }
}

function try3 {
    begin {
        $i = 0;
    }
    process {

        $i++
        if ($i % 2 -eq 0) {
            $Input | Join-String -DoubleQuote
        }
    }
    end {
        $Input | Join-String -sep ', ' -SingleQuote
    }
}
function try4 {
    # actually works

    begin {
    }
    process {
        $target = if ($Input -is 'IO.FileInfo') {
            $Input
        } else {
            $Input | Get-Item
        }
        $target
    }
    end {

    }
}
function try5 {
    # actually works

    begin {
        $files = [list[object]]::new()
        $dirs = [list[object]]::new()
        $all = [list[object]]::new()

    }
    process {
        if ($Input -is 'IO.FileInfo') {
            $files.Add( $Input )
        }
        if ($Input -is 'IO.DirectoryInfo') {
            $dirs.Add( $Input )
        }
        $all.Add( $Input )
    }
    end {
        H1 'files'
        $files

        H1 'dirs'
        $dirs

        H1 'both'
        $all
    }
}

<#
output:
> (ls . -Name | try5) | to->Json

        [
        "",
        "\u001b[38;2;235;203;139m# files\u001b[39m",
        "",
        "",
        "\u001b[38;2;235;203;139m# dirs\u001b[39m",
        "",
        "",
        "\u001b[38;2;235;203;139m# both\u001b[39m",
        "",
        {
            "Current": null
        },
        {
            "Current": null
        },
        {
            "Current": null
        },
        {
            "Current": null
        }
        ]
#>


function try6 {
    # actually works

    begin {
        $files = [list[object]]::new()
        $all = [list[object]]::new()
    }
    process {
        if ($Input -is 'IO.FileInfo') {
            $files.Add( $Input )
        }
        $all.Add( $Input )
    }
    end {
        return @{
            Files = $files
            All   = $all
        }
    }
}

$names = 'fred', 'jane', 'kate'
Label 'func' '1'
$names | try1
Hr
Label 'func' '2'
$names | try2
Hr
Label 'func' '3'
$names | try3
Hr

Label 'func' '4'
$names | try4
Hr

Label 'func' '5'
Get-ChildItem . -File -Name | try5
Hr

Label 'func' '6'
Get-ChildItem . -File -Name | try6
Hr


Get-ChildItem . -Name | try6 | ForEach-Object getenumerator
Hr
label 'getting null but cant index if you try'
((Get-ChildItem . -Name | try6 | ForEach-Object getenumerator)[1].Value)

Hr
