## Environment

| Module | Version |
|  -  |  -  |
| PSScriptAnalyzer | 1.20.0 |
| PowerShellEditorServices | 0.2.0 |
| Powershell | 7.1.4 |
| EditorServicesCommandSuite | 1.0.0 |
| PowerShellEditorServices.Commands | 0.2.0 |

## Initial script

```ps1
Get-ChildItem |
Where-Object Name -Like 'foo'

Get-ChildItem |
ForEach-Object Name
```

**Mode**: `IncreaseIndentationAfterEveryPipeline`


```ps1
Get-ChildItem |
    Where-Object Name -Like 'foo'

Get-ChildItem |
    ForEach-Object Name
```


**Mode**: `IncreaseIndentationForFirstPipeline`


```ps1
Get-ChildItem |
    Where-Object Name -Like 'foo'

Get-ChildItem |
    ForEach-Object Name
```


**Mode**: `IncreaseIndentationAfterEveryPipeline`


```ps1
Get-ChildItem |
    Where-Object Name -Like 'foo'

Get-ChildItem |
    ForEach-Object Name
```


**Mode**: `NoIndentation`


```ps1
Get-ChildItem |
Where-Object Name -Like 'foo'

Get-ChildItem |
ForEach-Object Name
```


**Mode**: `None`


```ps1
Get-ChildItem |
Name -Like 'foo'

Get-ChildItem |
Name
```


**Mode**: ``


```ps1
Get-ChildItem |
    Where-Object Name -Like 'foo'

Get-ChildItem |
    ForEach-Object Name
```

