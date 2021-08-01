# todo: should be a task
<#
    Idealy:
        Ninmonkey.Console\Get-NativeCommand 'gh'
#>
# Get-NativeCommand -
# Get-NativeCommand 'gh'
# gh completion --shell powershell

& {
    $ExportBase = Get-Item -ea stop (Join-Path "$PSScriptRoot" 'ExternalExamples')

    Label 'gh' 'github cli' | Write-Information
    if (Ninmonkey.Console\Get-NativeCommand 'gh') {
        # -ea Ignore) {
        Ninmonkey.Console\Invoke-NativeCommand -CommandName 'gh' -ArgumentList @(
            'completion'
            '--shell'
            'powershell'
        ) | Set-Content -Path (Join-Path $ExportBase 'gh.ps1')
        $Dest = (Join-Path $ExportBase 'rg.ps1')
        Label 'wrote' "'$Dest'" | Write-Information
    }


    Label 'rg' 'RipGrep' | Write-Information

    if (Ninmonkey.Console\Get-NativeCommand 'rg') {
        # -ea Ignore) {
        $completerFromChoco = Get-ChildItem "${Env:ChocolateyInstall}\lib\ripgrep" -Recurse _rg.ps1 | Select-Object -First 1
        if ($completerFromChoco) {
            Copy-Item $completerFromChoco -Destination (Join-Path $ExportBase 'rg.ps1')
            $Dest = (Join-Path $ExportBase 'rg.ps1')
            Label 'wrote' "'$Dest'" | Write-Information
        }
    }
    Label 'Build Completers' 'Done.' | Write-Information
} | ForEach-Object tostring
