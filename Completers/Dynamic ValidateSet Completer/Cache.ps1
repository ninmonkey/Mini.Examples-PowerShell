<#
from: <https://gist.github.com/ninmonkey/da05dcd8271cef5c59eb76e2563d4a0e>

For more, see: <https://vexx32.github.io/2018/11/29/Dynamic-ValidateSet/>
in a real script this can be scoped as a module-level variable
so it is actually not accessable or visable from the user
#>

$script:_cache = [hashtable]@{}

class Animal {
    # example showing validate [Attributes] can be applied to
    # members, or even sttand alone variables!
    [ValidateNotNullOrEmpty()]
    [ValidatePattern('^[a-z]+$')]
    [string]$Name

    [ValidateRange(0, 99)]
    [int]$Age
}

function _get_validProperty {
    <#
    .synopsis
        This calculalates which keys to return, which are used for autocomplete
    .notes
        in a real module this would be a private /internal function
    #>
    param()
    $script:_cache.Keys
}
function Set-Cache {
    <#
    .synopsis
        User facing function, caches values using  (key, value) pairs
    #>
    param(
        # Property Name
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property,

        # New Value
        [Parameter(Mandatory, Position = 1)]
        [object]$InputObject
    )

    $script:_cache[$Property] = $InputObject
}


function Get-Cache {
    <#
    .synopsis
        returns cached value using a key name.
    .description
        auto completes all valid (existing) key names

        type:
            "Get-Cache "

        then type:
            <tab> to cycle or <ctrl+space> to list all properties at once

        if your keys are bound to:

            Set-PSReadLineKeyHandler -Chord 'Tab' -Function TabCompleteNext
            Set-PSReadLineKeyHandler -Chord 'Ctrl+Spacebar' -Function MenuComplete

    #>
    param(
        [Parameter(Position = 0)]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                _get_validProperty
            }
        )]
        [ValidateScript(
            {
                $_ -in (_get_validProperty)
            }
        )]
        [string]
        $Property
    )

    if (! $Property ) {
        _get_validProperty
        return
    }

    $script:_cache[$Property]
}
