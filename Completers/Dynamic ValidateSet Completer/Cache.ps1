<#
from: <https://gist.github.com/ninmonkey/da05dcd8271cef5c59eb76e2563d4a0e>

For more, see: <https://vexx32.github.io/2018/11/29/Dynamic-ValidateSet/>
in a real script this can be scoped as a module-level variable
so it is actually not accessable or visable from the user
#>

# finish posting this to the SQL discord for PS5 completers

[hashtable]$script:__cache = @{}
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
        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [ValidateNotNull()]
        [object[]]$InputObject
    )

    begin {
        $items = [System.Collections.Generic.List[object]]::new()
    }
    process {
        $items.AddRange($InputObject)
    }
    end {
        $script:__cache[$Property] = $Items

        # "cache: set '$Property' = '$($Items.GetType()'"
        "cache: set '$Property' = {0}, count {1}" -f @(
            $Items.GetType().Name
            $Items.count
        ) | Write-Verbose
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

    .notes
        the behavior is:

            Get-Cache -Key 'good'
                returns value

            Get-Cache -Key 'notExisting'
                return nothing

            Get-Cache -Key 'notExisting' -Strict
                raise an error

            Get-Cache -List
                returns a list of valid keys
    .example
        PS> Set-Cache -Key 'now' -Value (get-date)
        PS> Get-Date | Set-Cache 'date'
        PS> Get-Cache date
        PS> Get-Cache <tab>

            # completes 'now', and 'date'

    #>
    param(
        # If key name is omitted, then print valid key names # sql chan?
        [Parameter(Position = 0, ValueFromPipeline)]
        [ArgumentCompleter({
                param(
                    $Command, $Parameter, $WordToComplete,
                    $CommandAst, $FakeBoundParams)
                _get_validCompletions
            })]
        [ValidateScript({
                if (! $Strict) {
                    return $True
                }
                $_ -in @(_get_validCompletions)
            })]
        [string]
        $Property,

        # list valid keys
        [switch]$List,

        #  don't error on bad key names
        [switch]$Strict
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
