<#
This Example Shows:

    - ScriptBlocks being called to validate values.


#>
function Get-User {
    param(
        # User's Id
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript( { $_.ToString().Length -eq 4 })]
        [int]$Id
    )
    "User: $Id"
}

$users = 234, 0534, -1534, -134, 1111 | ForEach-Object {
    Get-User $_
}
$users.count | Label 'Valid Users'
$users