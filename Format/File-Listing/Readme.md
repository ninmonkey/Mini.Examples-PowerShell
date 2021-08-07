Your format file will have a section like this

```html
<TableColumnItem>
    <PropertyName>Mode</PropertyName>
</TableColumnItem>
```

You can replace it with a `<ScriptBlock>`

```html
<TableColumnItem>
    <ScriptBlock>
        [string]$textAcc = ''
        switch($_.Mode[0]) {
            'd' {
                $textAcc += '📁'
                continue;
            }
            'l' {
                $textAcc += 'lnk'
                continue;
            }
            default {
                $textACC += '📄'
                continue;
            }
        }
        return $textAcc -join ''
    </ScriptBlock>
</TableColumnItem>
```

# Docs

- [about_Format.ps1xml](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_format.ps1xml?view=powershell-7.1)
- [about_Types.ps1xml](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_types.ps1xml?view=powershell-7.1)
- [Export-FormatData](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-formatdata?view=powershell-7)

[this file at gist](https://gist.github.com/ninmonkey/18203a0bc2b9fae38c95d9abcd9e3c12)

# Utilities

- <https://github.com/StartAutomating/EZOut>