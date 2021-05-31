#Requires -PSEdition Core

# I forget the coercion 'shorthand'

$nums = 80..100

# long hand
$nums | ForEach-Object {
    [Text.Rune]$_
} | Join-String


