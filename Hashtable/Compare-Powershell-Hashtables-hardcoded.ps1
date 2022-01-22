hr
<#

quote: [Hashtable remarks](https://docs.microsoft.com/en-us/dotnet/api/system.collections.hashtable?view=net-6.0#remarks)

> We don't recommend that you use the Hashtable class for new development. Instead, we recommend that you use the generic Dictionary<TKey,TValue> class. For more information, see Non-generic collections shouldn't be used on GitHub.

#>
$env_fromGi = Get-Item env:\
$env_fromLs = Get-ChildItem env:\
h1 'from Get-Item'
_dumpPsTypeName $env_fromGi
h1 'from Get-ChildItem'
_dumpPsTypeName $env_fromLs



hr -fg pink
function _typeSummary {
    param([object]$Object)
    $target = if ($Object -is 'type') {
        $tinfo = $object
    } else {
        $tinfo = $Object.GetType()
    }
    $tinfo = $object.GetType().FullName
    $Tinfo
}
function _genericSummary {
    param([object]$Object, [string]$Label)
    $tinfo = [string]$object.GetType()
    $Tinfo
}

[hashtable]$defaultHash = @{
    Species = 'Cat'
    Lives   = 9
}
h1 'Default hashtables from literal @{}'
_typeSummary $defaultHash


$defaultOrdered = [ordered]@{
    Z       = 10
    Length  = '14inches'
    Lives   = 9
    Species = 'Cat'
}
h1 'Default ordered from literal [ordered]@{}'
_typeSummary $defaultOrdered

# PSCustom object constructor is ordered by default
[pscustomobject]$Obj = [pscustomobject]@{
    Z       = 10
    Length  = '14inches'
    Lives   = 9
    Species = 'Cat'
}

hr -fg magenta

$env_fromGi = Get-Item env:\
$env_fromLs = Get-ChildItem env:\


h1 'as [pscustomobject]'
_typeSummary $Obj
_genericSummary $Obj


$hlist = @(
    $defaultHash, $defaultOrdered, $Obj,
    $env_fromGi
    $env_FromLs
)

# $summary = @{
#     'defaultHash'    = $defaultHash
#     'defaultOrdered' = $defaultOrdered
#     'Obj'            = $Obj
# }
# $hlist | ForEach-Object {
#     $_.GetType().FullName
#     # $newKey =
# }
# # $typeSummary = [ordered]@{}
# # $summary.GetEnumerator() | ForEach-Object {
# #     $newKey = $_.Key, '_types'
# #     $tinfo = ($_.Value)?.GetType()
# #     $newVal = @{
# #         'FullName' = $_.FullName
# #         'Name'     = $_.Name
# #     }

# # }
