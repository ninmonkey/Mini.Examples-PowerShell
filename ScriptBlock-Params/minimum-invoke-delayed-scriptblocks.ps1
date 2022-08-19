{ $PSItem }.InvokeWithContext($null, [psvariable]::new('_', '🐈'))


$MyName = 'fred'

$SB = {
    "Hi $MyName"
    $MyName = 'Jen'
}

$Sb.InvokeWithContext( $null, $Null )
$MyName