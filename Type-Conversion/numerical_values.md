
## Coercion

The type on the right hand side will coerce to the type on the left hand side

```ps1
🐒> $number  = '101'
🐒> $number.GetType().Name
String

🐒> 3 * $number  # left is [int]
303

🐒> $number * 3  # left is [string]
101101101
```

`$x += $y`
is shorthand for
`$x = $x + y`

The left-hand side decides the type to coerce to. 
This is why when you're testing for `null`, `$null` should always be on the left-hand side.

```ps1
$null -eq $something  # good
```
.

```ps1
🐒> $x = '101'
🐒> $x += 12
10112
🐒> $x.GetType().Name
String
🐒> $x = 300 + $x
10412

🐒> $x += 12
10112
🐒> $x.GetType().Name
Int32
```

## misc

### HexStrings to number
```ps1
[convert]::FromHexString('0f0f')
```

### Unicode `Codepoints` to `Rune` and back `int` <-> `Rune`

Don't cast to `[char]`. It will break on tons of valid unicode values. 

```ps1

# Bad
🐒> [char]0x1f408        

InvalidArgument: Cannot convert value "128008" to type "System.Char". Error: "Value was either too large or too small for a character."

# Good
🐒> [char]::ConvertFromUtf32( 0x1f408 ) 
🐈

# Back
[char]::ConvertToUtf32('🐒', 0)
128018
```

### `String` to `Rune`s or `Codepoints`

Unicode is weird. The number of codepoints and the length of a string using '.length' can be different. In dotnet terms:

```
| Dotnet Name | Unicode Name |
| ----------- | ------------ |
| Rune        | Codepoint    |
| Char        | Codeunit     |
| `Unicode`   | `UTF16-LE`   |
```

Warning, if docs don't specify utf8, `Unicode` means `utf16-le` encoded text

```md
🐒> [System.Text.Encoding]::UTF8, [System.Text.Encoding]::Unicode | ft

Preamble BodyName EncodingName    HeaderName WebName WindowsCodePage IsBrowserDisplay
-------- -------- ------------    ---------- ------- --------------- ----------------
utf-8    Unicode (UTF-8) utf-8      utf-8              1200             True
utf-16   Unicode         utf-16     utf-16             1200            False
```


```ps1
🐒> $runes = "`u{1f469}", "`u{200d}", "`u{1f466}"
🐒> $Family = $runes -join ''
👩‍👦

🐒> $Family.count ; $Family.length ;
1
5

🐒> $fam.EnumerateRunes() | ft

IsAscii IsBmp Plane Utf16SequenceLength Utf8SequenceLength  Value
------- ----- ----- ------------------- ------------------  -----
  False False     1                   2                  4 128105
  False  True     0                   1                  3   8205
  False False     1                   2                  4 128102


🐒> $runes -join ', '
👩, ‍, 👦

🐒> $runes -join ''
👩‍👦

🐒> $runes | Join-String -sep ', ' -DoubleQuote
"👩", "‍", "👦"
```