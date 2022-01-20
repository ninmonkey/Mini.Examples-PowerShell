function Export-PSDefaultParameterValues {
    Write-Warning 'Is not perfect, it stringifies values, which can be incorrect or static

    future: use AST to clone declarations?
    '
    
    $PSDefaultParameterValues.GetEnumerator() | Join-String -sep "`n" {
        $strKey = $_.key; $strVal = $_.value
        @(
            '$PSDefaultParameterValues['
            $strKey | Join-String -SingleQuote
            '] = '
            $strVal | Join-String -Separator ', ' -SingleQuote

        ) -join ''

        $strVal | ConvertTo-Json | ConvertFrom-Json -AsHashtable | Format-HashTable -Force | Out-String | Write-Verbose
    } | Sort-Object
}