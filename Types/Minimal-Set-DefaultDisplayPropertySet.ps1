# Sorta uses 7 in parts, but you can remove it easily

function InspectProperty {
    <#
    .synopsis
        example used to show how to set default property sets
    .link
        Update-TypeData
    #>
    [OutputType('ninProp')]
    param(
        # What to inspect
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $InputObject
    )
    process {

        $InputObject.psobject.properties | ForEach-Object {
            $meta = @{
                'PSTypeName'      = 'ninProp'
                'Foo'             = '🐒'
                'Name'            = $_.Name
                'TypeNameOfValue' = $_.TypeNameOfValue
                'Type'            = $_.GetType() ?? '[error]'
                'TypeStr'         = $_.GetType().Name | Join-String -op '[' -os ']'
                'Value'           = $_.Value
                'ValueStr'        = $_.Value ?? "[`u{2400}]"
            }

            $meta['ValueStr'] = $_.Value ?? "[`u{2400}]"
            return [pscustomobject]$meta
        }
    }
}


$TypeData = @{
    TypeName                  = 'ninProp'
    DefaultDisplayPropertySet = 'Foo', 'Name', 'TypeStr', 'Value' # FL
    DefaultDisplayProperty    = 'ValueStr' # FW
    DefaultKeyPropertySet     = 'Name', 'TypeStr' # sort and group
}
Update-TypeData @TypeData -Force

$props = Get-Item . | InspectProperty
$selected = $props
| Select-Object -First 7
# | Get-Random -Count 4


$props | Format-List
# Hr

$selected | Format-Wide -AutoSize
# Hr
$props | s -first 10 | Format-Table -AutoSize
# Hr
