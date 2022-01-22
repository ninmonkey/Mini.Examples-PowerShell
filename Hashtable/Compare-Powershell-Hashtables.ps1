<#

quote: [Hashtable remarks](https://docs.microsoft.com/en-us/dotnet/api/system.collections.hashtable?view=net-6.0#remarks)

> We don't recommend that you use the Hashtable class for new development. Instead, we recommend that you use the generic Dictionary<TKey,TValue> class. For more information, see Non-generic collections shouldn't be used on GitHub.

#>




[hashtable]$defaultHash = @{
    Species = 'Cat'
    Lives   = 9
}

System.Collections.Specialized.OrderedDictionary
$defaultOrdered = [ordered]@{
    Z       = 10
    Length  = '14inches'
    Lives   = 9
    Species = 'Cat'
}

# PSCustom object constructor is ordered by default
[pscustomobject]$Obj = [pscustomobject]@{
    Z       = 10
    Length  = '14inches'
    Lives   = 9
    Species = 'Cat'
}

$hlist = $defaultHash, $defaultOrdered, $Obj

$summary = @{
    'defaultHash'    = $defaultHash
    'defaultOrdered' = $defaultOrdered
    'Obj'            = $Obj
}
$hlist | ForEach-Object {
    $_.GetType().FullName
    # $newKey =
}
$typeSummary = [ordered]@{}
$summary.GetEnumerator() | ForEach-Object {
    $newKey = $_.Key, '_types'
    $tinfo = ($_.Value)?.GetType()
    $newVal = @{
        'FullName' = $_.FullName
        'Name'     = $_.Name
    }

}
