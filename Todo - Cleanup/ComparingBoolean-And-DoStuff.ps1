
function DoIt {
    [CmdletBinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        $Label,

        [Parameter()][switch]$DoStuff
    )
    end {
        [pscustomobject]@{
            PSTypeName                    = 'SwitchTestResult'
            Id                            = $script:LastIndex++
            Label                         = $Label
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
$lastIndex = 0
$fullDetails = @(
    DoIt 'Omit Param'
    DoIt 'Switch On' -DoStuff
    DoIt 'Explicit True' -DoStuff:$true
    DoIt 'Explicit False' -DoStuff:$false
    DoIt 'Explicit Null' -DoStuff:$null
)
$RemoveConstantTests = @(
    # remove ones that are constant
    '[bool]DoStuff'
    'DoStuff != $null?'  # always true
    'DoStuff == $null?'  # always false
    'MyInvoke.BoundParam'
    'PSBoundParameters == $null?'
    'PSBoundParameters'
    'MyInvoke.BoundParams_str'
)

$results = $fullDetails | Select-Object -Exclude $RemoveConstantTests
hr -fg magenta

h1 'Removed Tests'
$fullDetails | s -prop $RemoveConstantTests | Format-Table -AutoSize


h1 'Tests'
$results | Format-Table -AutoSize

if ($false) {

    $results
    hr
    $results | Format-Table -AutoSize
    hr
    $results
    # | Sort-Object -ex
    # | s -ExcludeProperty 'MyInvoke.BoundParam', 'PSBoundParameters', 'PSBoundParameters == $null?'
    | Format-Table -AutoSize -Wrap
    hr
    # Format-dict -InformationAction $results

    $qq | StrReplace '{' "{`n" | StrReplace ';' ";`n" | StrReplace '}' "`n}"
}
