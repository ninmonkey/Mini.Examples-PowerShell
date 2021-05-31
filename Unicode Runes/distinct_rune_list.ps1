# f
$InputSample = @{
    'Many'    = @'
    ",T—⁞→⇠⇡⇢⇣⇽⇾┆┐⚙➟⭪⭫⭬⭭⸺⸻️🌎🌐🎨🏃🐌🐒🐛🐢👍💡💻📋📌📹🔑🔥🕷🕹🖥🚀",
            "⇢⁞ ⁞ ┐⇽⇾— ⚙️💡🏃🐢🐌 ⇠⇡⇢⇣🚀📋⇢⇢T ⇢ 📌→🎨🐒🐛💻👍🕹️🌎🌐⁞┐➟⇽⇾—⁞⚙️💡📋📹🔑🔥⁞,┐⇽🕷️🕹️🖥️⇽⭪,⭫,⭬,⭭,⸺,⸻┐┆",
            "todo: make select-box so they aren't so many",
            "T——⁞⁞⁞→⇠⇡⇢⇢⇢⇢⇢⇣⇽⇽⇽⇾⇾┆┐┐┐⚙⚙➟⭪⭫⭬⭭⸺⸻️️️️️️🌎🌐🎨🏃🐌🐒🐛🐢👍💡💡💻📋📋📌📹🔑🔥🕷🕹🕹🖥🚀",
'@

    'Shorter' = '"⸻⸺T🖥⭭⭬⭫⭪️⇾⇽nt📌🔑m┆:┐🐛🐢📋→bh🏃🌐, 🌎⇣⇢⇡⇠🕷🐒🚀"➟ x🐌💻sr—🔥oy🕹🎨kl-edc⁞a👍⚙💡📹'
}

$ExcludeSet = @{
    'Default' = 'a'..'z' + 'A'..'Z' + '0'..'9'
    'Ascii'   = 0..0x7f | ForEach-Object { [rune]$_ }
}

<#
future:
    - [ ]  if not using WinPS, are rune constructors useful? ex:

0..0x7f | %{ [Text.Rune]$_ }

#>

$all = @{}
$x.EnumerateRunes() | ForEach-Object {
    $all[ $_.Value ] = $_
}

# quick hack, use unicode metadata instead
$ToStrip = 'a'..'z' + 'A'..'Z' + '0'..'9'

function Sort-Rune {
    param( [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$InputString
        begin { $runeList = [list[object]]::new() }
        process {
            foreach ($text in $InputString) {
                $text.EnumerateRunes() | $runeList.Add( $_ )
            }
        }
        end {
            [hashtable]$finalSet = @{}
            $runeList | ForEach-Object { $finalSet[ $_.Value ] = $_ }

        }
    }
    # get distinct, filtered, sorted list
    $all.Values
    | Sort-Object -Descending -Unique
    # strip alpha
    | Where-Object { ('a'..'z' + 'A' + 'Z' ) -notcontains ($_.ToString()) }
    | Join-String -sep ''