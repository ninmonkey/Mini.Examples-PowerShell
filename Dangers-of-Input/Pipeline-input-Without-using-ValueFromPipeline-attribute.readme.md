# pre

- [pre](#pre)
- [Minimum Example](#minimum-example)
- [Docs](#docs)

# Minimum Example

The only requirement for `$Input`  is that you have a `-Process` block

```ps1
🐒> function doubleIt { process { $Input * 2 } }
    
    4, 'cat', 34 | doubleIt

    # output:
    4
    4
    cat
    cat
    34
    34
```

# Docs

- [about_automatic_variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.3#input)