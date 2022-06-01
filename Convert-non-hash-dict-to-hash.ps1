@'
context
>> output is
> You can turn it into a proper dictionary if you want:
'@

Get-Package | ForEach-Object {
    $metaDataTable = [ordered]@{}
    $mdi = $_.Metadata
    $mdi.psbase.Keys.ForEach{ $metaDataTable[$_.LocalName] = $($mdi[$_.LocalName]) }

    $metaDataTable
}