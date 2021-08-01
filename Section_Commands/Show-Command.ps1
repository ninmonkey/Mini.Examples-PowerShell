Show-Command Get-Date
<#
1] Displays the command UI
    Now enter day = 3, year = 2000
    click 'copy'

Clipboard copies the command:
    Get-Date -Day 3 -Year 2000

#>

Show-Command ls
<#
2]
    Enter Path = '.'
    click run

the console replaces your input with the value
    Get-ChildItem -Path .

#>

Show-Command ls -PassThru
<#
3] Same thing, but use -Passthru

#>
# Instead of replacing the console command, it returns the command as a regular string.
