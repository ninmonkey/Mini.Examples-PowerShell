
## Declaring Process

```ps1
$Names = 'ben', 'sue', 'fred'
Label 'Function' 'DangerTest2A'
 $names | DangerTest2A
 ```
[Danger-EndBlock.ps1](Danger-EndBlock.ps)

## Referencing Enumerator Twice

[Danger-collectFiles.ps1](Danger-collectFiles.ps1)

### Code


```ps1
(Get-ChildItem . -File).count | Join-String -op 'File count: '

# the exact same condition
(Get-ChildItem . -File
| Where-Object { $_ -is 'IO.FileInfo' } ).count
| Join-String -op 'Count using Operator "-is": '


# If File count is 3, what will this return ?
Get-ChildItem . | dangerTest1

```
### Output

```ps1
File count: 6
Count using Operator "-is": 6
Found file: 0
Expect Count: 6
```