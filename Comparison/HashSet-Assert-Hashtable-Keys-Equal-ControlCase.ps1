using namespace System.Collections.Generic
# todo: blog post, or save or something.

# to refactor to a pester helper
$h1 = @{ 'species' = 'dog' ; 'lives' = 1 }
$h2 = @{ 'lives' = 1; 'Species' = 'dog' }

$hash1 = [HashSet[string]]::new(
    [string[]]($h1.Keys)
)
$hash2 = [HashSet[string]]::new(
    [string[]]($h2.Keys)
)

'blog'



$hash1.SetEquals( $hash2 )
| Join-String -op '$hash1.SetEquals( $hash2 ):  ' | Write-Color orange


$hash1 = [HashSet[string]]::new(
    [string[]]($h1.Keys),
    [System.StringComparer]::OrdinalIgnoreCase
)
$hash2 = [HashSet[string]]::new(
    [string[]]($h2.Keys),
    [System.StringComparer]::OrdinalIgnoreCase
)
$hash1.SetEquals( $hash2 )
| Join-String -op '$hash1.SetEquals( $hash2 ):  ' | Write-Color orange

Hr
$hash1 | ForEach-Object {
    @( $_ ; $hash2.Contains( $_ ) ) -join ' '
}
Hr

$hash2.Contains( [string[]]$hash1 ) # false
Hr
$hash2.Contains( [string[]]@('lives', 'species' ) ) # false
Hr
$hash2.Contains('lives') # true
Hr
$hash1 -join ', ' | Write-Color green | Join-String -op '$hash1 = ' -SingleQuote -sep ', '
$hash2 -join ', ' | Write-Color yellow | Join-String -op '$hash2 = ' -SingleQuote -sep ', '
