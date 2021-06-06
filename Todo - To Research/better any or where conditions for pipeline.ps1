

function _enumerateProp {
    param(
        # input
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    process {
        $InputObject.psobject.properties
    }
}


$item = Get-ChildItem 'c:\' -Directory | Select-Object -First 1
label @'
    This works fine, but, what if you don't want to actually mutate the result?
    prefer to preserve it like
        "Sort-Object"
        Sort-Object { $_.GetType().Name }
'@
_enumerateProp $item | Where-Object Name -Match 'name' | Format-Table

$bigSample = Get-ChildItem c:\ -Depth 1 | Select-Object -First 100

if ($false) {


    h1 'naive attempt'
    function _filterByPropValue {
        param(
            # input
            [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
            [object]$InputObject

            # # which prop
            # [Parameter(Mandatory, Position = 0)]
            # [string]$Property


        )

        process {
            $InputObject.psobject.properties | ForEach-Object {

            }
        }
    }

    Hr
    h1 'Goal: simplfy where-object, yet variable' -fg magenta
    $x = Get-ChildItem c:\ -Depth 1 | Select-Object -First 200
    $y = Get-ChildItem c:\ -Depth 1 | Select-Object -First 200  | Where-Object { $_.Name -match 'windows' -or $_.Name -match 'log' }
    $y = Get-ChildItem c:\ -Depth 1 | Select-Object -First 200  | Where-Object { $_.Name -match 'windows' }
    $x.count | Label '$x.count'
    $y.count | Label '$y.count'

    # $item.gettype() | prop
}
