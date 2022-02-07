
$lastIndex = 0
function DoIt {
    <#
    .synopsis
        Compare all possible permutations of [switch] IsPresent
    #>

    [CmdletBinding()]
    param(
        # test name
        [parameter(Mandatory, Position = 0)]$Label,
        # target
        [Parameter()]
        [AllowNull()] #doesn't actually make it nullable
        [switch]$DoStuff
    )
    end {
        [pscustomobject]@{
            # Several of these are always constant values, so I strip them
            # on the final table
            'PSTypeName'                  = 'SwitchTestResult'
            'Id'                          = $script:LastIndex++
            'Label'                       = $Label
            '.IsPresent?'                 = $DoStuff.IsPresent
            '[bool]DoStuff'               = [bool]$DoStuff
            'DoStuff'                     = $DoStuff
            'DoStuff == $null?'           = $null -eq $DoStuff
            'DoStuff != $null?'           = $null -ne $DoStuff
            'MyInvoke.BoundParams'        = $PSCmdlet.MyInvocation.BoundParameters
            'MyInvoke.BoundParams_str'    = $PSCmdlet.MyInvocation.BoundParameters | Format-HashTable SingleLine | StrReplace ';' ";`n"

            'PSBoundParameters == $null?' = $null -eq $PSBoundParameters # always false

            PSBoundParameters             = $PSBoundParameters
            PSBoundParameters_str         = $PSBoundParameters | Format-HashTable SingleLine | StrReplace ';' ";`n"
        }

    }
}
$fullDetails = @(
    DoIt 'Omit Param'
    DoIt 'Switch On' -DoStuff
    DoIt 'Explicit True' -DoStuff:$true
    DoIt 'Explicit False' -DoStuff:$false
    DoIt 'Explicit Null' -DoStuff:$null
)
$RemoveConstantTestNames = @(
    # remove ones that are constant
    '[bool]DoStuff'
    'DoStuff != $null?'  # always true
    'DoStuff == $null?'  # always false
    'MyInvoke.BoundParam'
    'PSBoundParameters == $null?'
    'PSBoundParameters'
    'MyInvoke.BoundParams_str'
)

$results = $fullDetails | Select-Object -Exclude $RemoveConstantTestNames
hr -fg magenta

h1 'Removed Tests'
$fullDetails | s -prop $RemoveConstantTestNames | Format-Table -AutoSize

h1 'Tests'
$results | Format-Table -AutoSize

function Build-ResultTable {
    <#
    .Quick hack to build Markdown.
    #>
    $results | ForEach-Object {
        '| Name | Value | '
        '| - | - |'
        $_ | Iter->Prop | ForEach-Object {


            if ($_.Value -is [System.Collections.IDictionary]) {
                $Value = $_.Value | Format-HashTable SingleLine
            } else {
                $Value = $_.Value
            }
            $_.Name, $Value | str Table
        }
        "`n"
    }

}

Build-ResultTable | Set-Content -Path (Join-Path $PSScriptRoot 'IsPresent-results.md')
Build-ResultTable | Set-Content -Path (Join-Path $PSScriptRoot '.output/IsPresent-results.md')

$results | Format-Table -AutoSize | Out-String -Width 999 | Out-File -Path (Join-Path $PSScriptRoot '.output/IsPresent-results.ansi')
