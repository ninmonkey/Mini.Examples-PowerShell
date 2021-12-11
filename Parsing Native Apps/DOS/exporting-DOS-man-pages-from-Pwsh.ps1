#Requires -Version 7.0


$App = @{ Root = Get-Item -ea stop $PSScriptRoot }
Set-Location $App.Root
$App += @{
    Export = Join-Path $App.Root 'output'
}
$eaIgnore = @{
    # 'ea' = 'Ignore'
    'ea' = 'Continue'
}
mkdir $App.Export -ea ignore

function New-ExportDocSplat {
    <#
    .synopsis
        Exports a command's manual to $App.Export
    #>
    param($Label)

    $splatDoc = @{
        # Path                   = 'cmd'
        NoNewWindow            = $true
        RedirectStandardOutput = Join-Path $App.Export "$Label.txt"
        RedirectStandardError  = Join-Path $App.Export "$Label.stderr.txt"
        Wait                   = $false # If not, faster, but autodelete tries while locked
    }
    $splatDoc
}

function Find-DosCommandInfo {
    <#
    .synopsis
        Get list of commands, export to 'CommandNames.csv'
    #>
    @(
        $exportSplat = New-ExportDocSplat -label 'Help'
        Start-Process 'cmd' @exportSplat -args @('/C', 'Help')
    ) | Out-Null

    # parse the help page, remove wrapped lines and header/footer

    Get-Content -Path $exportSplat.RedirectStandardOutput
    | s -Skip 1
    | s -SkipLast 1
    | Where-Object {
        $_ -notmatch '^\s+'
    }
    | ForEach-Object {
        $k, $v = $_ -split '\s+', 2
        if ( [string]::IsNullOrWhiteSpace($k) ) {
            return
        }
        $Name, $Desc = $_ -split '\s+', 2
        $meta = [pscustomobject]@{
            PSTypeName  = 'DosCommandInfo'
            Name        = $Name
            Description = $Desc

        }
        $meta
        # [pscustomobject]@{ Command = $k; Description = $v }
    }
    return
}

# "main" , the entry point

Find-DosCommandInfo

$pathCsv = Join-Path $App.Export 'CommandNames.csv'
$commands = Import-Csv -LiteralPath $pathCsv
$commands | Sort-Object Command
"Wrote: '$pathCsv'"

$namesToQuery = $commands
| Where-Object Command # filter any blanks
| ForEach-Object Command | Sort-Object -Unique


# $namesToQuery = 'CMD', 'FOR' # or just generate a couple
$namesToQuery | ForEach-Object {
    $Label = $_
    $exportSplat = New-ExportDocSplat -label $Label
    # "<cmd> /?" and "<help> <cmd>" seem to be the same
    # So I chose 'help' because it is the safer one on failures
    Start-Process 'cmd' @exportSplat -args @('/C', 'Help', $Label)

    Get-Item $exportSplat.RedirectStandardError @eaIgnore
    | Where-Object Length -EQ 0 | Remove-Item -ea ignore


    @(
        'Wrote: '
        @(
            $exportSplat.RedirectStandardOutput
            $exportSplat.RedirectStandardError
        )
        # | To->RelativePath
        | Join-String -sep "`n" -DoubleQuote
    )
}


# hr
# $commands
# | Format-List
& {
    # remove empty files. Sleeping makes a locked file less likely
    # otherwise 'Start-Process -Wait' fixes any locked file race
    Start-Sleep 0.3
    Get-ChildItem $App.Export -Recurse *stderr*
    | Where-Object Length -EQ 0 | Remove-Item -ea ignore
}

$findErrors = Get-ChildItem .\output\ *stderr* -Recurse | Where-Object Length -NE 0
foreach ($err in $findErrors) {
    @(
        'command had errors: ', $err.Name -join ''
        $err.FullName | Join-String -DoubleQuote
        Write-ConsoleHorizontalRule

        Get-Content $err
    ) | Write-TextColor -fg 'orange'
}
