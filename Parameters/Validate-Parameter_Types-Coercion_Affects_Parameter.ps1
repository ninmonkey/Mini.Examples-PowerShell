@'
This example shows

    1. How to use validate parmeters with a scriptblock
        from: <Validate-Length-of-String-Parameter.ps1>

    2. How type coercion is involved

        Validation will create
            5 errors as int parameter

        Set the type to 'string', and
            there's only 2 errors

    3. Unicode lengths are different
        'string'.length returns the length
            as utf-16le encoded text

        'string'.enumerateRunes()
            returns the number of 'codepoints' instead of
            the number of bytes it would require (when encoded)

'@
function Get-User {
    param(
        # User's Id
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript( { $_.ToString().Length -eq 4 })]
        [int]$Id
        # [string]$Id  # try running with type: string
    )
    "User: $Id"
}

$userList = @(
    '🐒'
    '🐒🐒'
    "`u{1f412}`u{1f412}"
    '-252'
    -134
    1234
    'Jane'
    'Doe'
    '9999'
)

$error.Clear()
$validUserList = $userList  | ForEach-Object {
    Get-User $_
}
$Error.count | Label "Total Ids that didn't Validate"

$userList | Join-String -sep ', ' -SingleQuote
| Label 'userList'

$validUserList.count | Label 'ValidUserCount'
$validUserList | Join-String -sep ', ' -SingleQuote
| Label 'ValidUsers'

