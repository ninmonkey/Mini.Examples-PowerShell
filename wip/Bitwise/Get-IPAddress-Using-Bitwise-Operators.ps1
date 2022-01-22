
$accum = 0
[byte[]]$bytes = 192, 168, 53, 1
$Ip = [ordered]@{
    'FromBytesArray' = [ipaddress]::new( $bytes )
}


$accum = 0
# $eaBreak = @{ 'ea' = 'break' }
$ErrorActionPreference = 'continue'

@(

)


foreach ($i in 0..3) {
    $accum | bits @eaBreak #| label "start: $I"
    $new = $bytes[$i] -shl ($i * 8)


    $accum | bits @eaBreak #| label "after: $I"
    $accum = $accum -bor $accum
    $accum | bits @eaBreak # | label "after: $I"
}
hr
# return


$accum = 0
$i = 0
[byte[]]@(192, 168, 53, 1)
| ForEach-Object {
    $i++
    $next = $_
    $accum | bits @eaBreak | label 'cur'
    $accum = $accum -shl 8
    $accum = $accum -bor $_
    $accum | bits @eaBreak | label 'new'
    hr
}
$ip2 = [ipaddress]::new(  $accum )
