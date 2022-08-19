{ $PSItem }.InvokeWithContext($null, [psvariable]::new('_', '🐈'))


$MyName = 'fred'

$SB = {
    "Hi $MyName"
    $MyName = 'Jen'
}
$SB2 = {
    "Hi $MyName"
    Set-Variable -scope 1 -Name 'MyName' -Value 'Jen'
    # $MyName = 'Jen'
}

$Sb.InvokeWithContext( $null, $Null )
$MyName

function bar {
    $Sb.InvokeWithContext( $null, $Null )
}
function bar2 {
    param($x)
    $MyName
    $x.InvokeWithContext( $null, $Null )
    $MyName
}

bar

$MyName

bar2 $sb

bar2 $sb2
$myName