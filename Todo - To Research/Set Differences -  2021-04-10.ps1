
using namespace System.Collections.Generic

$namesA = 'bob', 'jen', 'bob'
$namesB = 'jen', 'fred'

$setA = [hashset[string]]@($namesA)
$setB = [hashset[string]]@($namesB)

$SetA | Join-String -sep ', ' | Label 'A'
$SetB | Join-String -sep ', ' | Label 'B'


$setA.ExceptWith( $setB ) # A - B

$SetA | Join-String -sep ', ' | Label 'A - B'

if ($false) {

    $namesA = 'bob', 'jen', 'bob'
    $namesB = 'jen', 'fred'
    $setA = [hashset[string]]::new( $namesA )
    $setB = [hashset[string]]::new( $namesB )

    $setA.ExceptWith( $setB ) # A - B

    $namesA | ForEach-Object { [void]$setA.Add( $_ ) }
    $namesB | ForEach-Object { [void]$setB.Add( $_ ) }

    # $setA = [hashset[string]]$namesA
    # $setB = [hashset[string]]$namesB

    hr 3

    $hs_manual1 = [HashSet[string]]::new()
    $hs_manual1.Add('b')
    $hs_manual1.Add('c')

    $hs_manual2 = [HashSet[string]]::new()
    $hs_manual2.Add('a')
    $hs_manual2.Add('b')

    Label 'intersect'
    $res = $hs_manual2.IntersectWith( $hs_manual1 )
    hr
    $res

}