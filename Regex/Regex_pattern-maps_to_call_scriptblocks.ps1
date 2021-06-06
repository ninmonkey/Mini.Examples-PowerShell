function doStuff { 'stuff' }

$RegexList = @(
    @{
        Pattern     = '\-d'
        ScriptBlock = {
            Get-ChildItem -Directory | Select-Object -First 3
            | Write-Host -fore 'red' | Format-Wide
        }
    }
    @{
        Pattern     = '\-f'
        ScriptBlock = {
            Get-ChildItem -File | Select-Object -First 3
            | Write-Host -fore 'green' | Format-Wide
        }
    }
    @{
        Pattern     = '-s'
        ScriptBlock = Get-Item function:\doStuff
    }
)

# all
'-d', '-f', '-s' | ForEach-Object {
    $curLine = $_
    $RegexList | ForEach-Object {
        $curAction = $_
        if ($curLine -match $curAction['Pattern']) {
            & $curAction['ScriptBlock']
        }
    }
}

function ActionStuff {
    Get-ChildItem -Directory | Select-Object -First 3
    | Write-Host -fore 'red' | Format-Wide
}
