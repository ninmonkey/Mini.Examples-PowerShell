& {
    'Get Value of jump list'

    $Path = @{}
    $Path.JumpParent = 'HKCU:\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

    h1 'Explorer\Advanced: Properties'
    Get-ItemProperty $Path.JumpParent -ov LastItem

    h1 'Explorer\Advanced: list'
    Get-ChildItem $Path.JumpParent -ov LastLs

    Set-ItemProperty -Path $Path.JumpParent -Name '(default)' -Value 'one' -WhatIf


    Hr 10
    Set-Location $path.JumpParent

    h1 'current value of key'
    $Path.JumpParent | Get-ItemProperty -Name 'JumpListItems_Maximum'
    $Path.JumpParent | Get-ItemProperty -Name 'nin'

    Set-ItemProperty -Path $Path.JumpParent -Name 'JumpListItems_Maximum' -Value ([int32]0x30) -WhatIf
}
# [hashtable]$PathsRegistry = @{
#     'JumpList' = @{
#         'Description' = 'Number of pins / jump list on right click'
#         'Path'        =
#     }
# }