```ps1
# ? is Alias for where, nice when on the CLI
$Scriptblock = {
    $_ -ne 'someserveronthelist'
}
$server = Get-Content server.txt | ? -ne 'someserverionthelist'
$server = Get-Content server.txt | Where-Object -ne 'someserverionthelist'
$server = Get-Content server.txt | Where-Object { $_ -ne 'someserverionthelist' }
$server = Get-Content server.txt | Where-Object $Scriptblock
```

```ps1
# You can chain conditions
$all_files = ls . -Recurse 4
$big_zip = $all_files | Where-Object Length -Gt 10mb | Where-Object Extension -EQ '.zip'
```
