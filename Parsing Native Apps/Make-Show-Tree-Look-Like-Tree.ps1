$newItemSplat = @{
    ItemType = 'Directory'
    Path     = $PSScriptRoot
    Name     = '.output'

    # Force    = $true
}

New-Item @newItemSplat -ea Ignore

& {
    # a list of literals, not patterns, to replace

    $CachedOutput = @'
+--AngleSharp
|  \--AngleSharp
|     +--.github
|     |  +--ISSUE_TEMPLATE
|     |  \--workflows
|     +--docs
|     |  +--general
|     |  \--tutorials
|     +--src
|     |  +--AngleSharp
|     |  +--AngleSharp.Benchmarks
|     |  +--AngleSharp.Core.Docs
|     |  +--AngleSharp.Core.Tests
|     |  \--TestGeneration
|     \--tools
\--kamome283
   \--AngleParse
      +--AngleParse
      |  +--Resource
      |  \--Selector
      +--AngleParse.Test
      |  +--Resource
      |  \--Selector
      \--build
'@
    $Replacements | ConvertTo-Json
    $Replacements = @(
        , ('-', '─')
        , ('\', '└')
        , ('-', '─')
        , ('|', '│')
        , ('+', '├')
    )

    PSScriptTools\Show-Tree c:\programs -Depth 3
    | Join-String -sep "`n" | ForEach-Object {
        $accum = $_
        foreach ($pair in $Replacements) {
            $pattern = [regex]::Escape( $pair[0] )
            $replace = $pair[1]
            $accum = $accum -replace $pattern, $replace
        }
        $accum
    }

    h1 'Original (cached)'
    # $CachedOutput

    h1 'Replacement mapping'
    , $Replacements | Join-String -sep "`n" {
        '{0} ⇒ {1}' -f @(
            $_[0] | New-Text -fg red | ForEach-Object tostring
            $_[1] | New-Text -fg green | ForEach-Object tostring
        )
    }

} | Out-String | Out-File -FilePath './.output/show-tree.ansi' -Encoding utf8 -Force
# todo: it's stripping ansi
