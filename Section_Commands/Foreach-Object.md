# See also: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.2>

# `ForEach-Object 'x'` is the `-MemberName` param

```ps1
🐒> Get-Module | Select-Object -First 3
| ForEach-Object Name

🐒> Get-Module | Select-Object -First 3
| ForEach-Object -MemberName Name
```

# `-MemberName` with `-Args` will invoke functions

```ps1
🐒> 127 | % tostring x
7f

# Is really calling this
127 | ForEach-Object -MemberName 'ToString' -ArgumentList 'x'

# and this
🐒> 'foo,bar,cat' | ForEach-Object Split 'a'
foo,b
r,c
t

# Is invoking this:
ForEach-Object -MemberName 'Split' -ArgumentList 'a' -InputObject 'foo,bar,cat'
```

However, remember that the pipeline unrolls arrays. The result is different if you force an array:

```ps1
🐒> (10, 30) | % Tostring
10
30

🐒> ,(10, 30) | % Tostring
System.Object[]
```