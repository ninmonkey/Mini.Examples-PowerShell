
$Sample1 = @'
ls . | ?{ $_.Length -gt 1 } | %{ $_.Name }
'@


function Invoke-ClipboardFormatter {
    param(
        # Format but do not write to clipboard
        [alias('WhatIf')] # sorta bad
        [Parameter()]
        [switch]$PassThru
    )
    $orig = Get-Clipboard
    $orig | Join-String -sep ',' | Label 'Old' | Write-Verbose

    $InputText = Get-Clipboard | Join-String -sep "`n"
    Invoke-Formatter -ScriptDefinition $InputText -Settings @{

    }

    $formatted  | Label 'Result' | Write-Information

    $formatted


}

if ($True) {
    # test
    if ($Sample1 -eq (Get-Clipboard)) {
        # Label 'already done'
    }
    else {
        # Label 'Nope'
        Set-Clipboard $Sample1
    }
}

h1 'with Info'
Invoke-ClipboardFormatter -PassThru -InformationAction continue
h1 'without Info'
Invoke-ClipboardFormatter -PassThru
h1 'done'

# Get-Help Invoke-Formatter -Online