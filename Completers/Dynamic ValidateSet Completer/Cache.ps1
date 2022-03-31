<#
from: <https://gist.github.com/ninmonkey/da05dcd8271cef5c59eb76e2563d4a0e>

For more, see: <https://vexx32.github.io/2018/11/29/Dynamic-ValidateSet/>
in a real script this can be scoped as a module-level variable
so it is actually not accessable or visable from the user
#>

[hashtable]$script:__cache = @{}

class Animal {
    # validate [Attributes] can be applied to members,
    # or even stand alone variables!
    [ValidateNotNullOrEmpty()]
    [ValidatePattern('^[a-z]+$')]
    [string]$Name

    [ValidateRange(0, 99)]
    [int]$Age
}

function _get_validCompletions {
    <#
    .synopsis
        This function is the 'magic'. Valid values change during run time,
    .description
        If you were using [ValidateSet()], this generates the values that
        would have been placed there. But, it's re-evaluated, they're dynamic.

        This calculalates which keys to return, which are used for autocomplete
        in a real module this would be a private /internal function
    .link
        https://vexx32.github.io/2018/11/29/Dynamic-ValidateSet
    #>
    param()
    $script:__cache.Keys
}
function Set-Cache {
    <#
    .synopsis
        User facing function, caches values using  (key = value) pairs
    .example
        PS> Set-Cache -Key 'now' -Value (get-date)
        PS> Get-Date | Set-Cache 'date'
        PS> Get-Cache date
    #>
    param(
        # Property / Key Name that you are caching under
        [Alias('Key')]
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property,

        # Object to Store
        [Alias('Value')]
        [Parameter(Mandatory, 1, ValueFromPipeline)]
        [ValidateNotNull()]
        [object]$InputObject
    )

    begin {
    }
    process {
    }
    end {
        $script:__cache[$Property] = $InputObject
        Write-Verbose "cache: set '$Property' = '$InputObject'"
    }
}

function Get-Cache {
    <#
    .synopsis
        returns cached value using a key name. example forcing like a validateset
    .description
        auto completes all valid (existing) key names

        type:
            "Get-Cache "

        then type:
            <tab> to cycle or <ctrl+space> to list all properties at once

        if your keys are bound to:

            Set-PSReadLineKeyHandler -Chord 'Tab' -Function TabCompleteNext
            Set-PSReadLineKeyHandler -Chord 'Ctrl+Spacebar' -Function MenuComplete
    .example
        PS> Set-Cache -Key 'now' -Value (get-date)
        PS> Get-Date | Set-Cache 'date'
        PS> Get-Cache date
        PS> Get-Cache <tab>

            # completes 'now', and 'date'

    #>
    param(
        # If key name is omitted, then print valid key names
        [Parameter(Position = 0, ValueFromPipeline)]
        [ArgumentCompleter({
                param(
                    $Command, $Parameter, $WordToComplete,
                    $CommandAst, $FakeBoundParams)
                _get_validCompletions
            })]
        [ValidateScript({
                if ($NotStrict) {
                    return $True
                } # test if toggle works properly
                $_ -in @(_get_validCompletions)
            })]
        [string]
        $Property,

        # list valid keys
        [switch]$List,

        # don't error on bad key names
        [switch]$NotStrict
    )
    begin {
    }
    process {
        if (! $Property ) {
            _get_validCompletions
            return
        }
        Write-Verbose "cache: get '$Property'"
        $script:__cache[$Property]
    }
    end {
    }

}
