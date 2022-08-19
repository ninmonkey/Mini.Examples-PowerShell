using namespace System.Collections.Generic

class NothingToSee {
    hidden [AllowNull()]$Nothing
}
function doSomething {
    <#
    .synopsis
        Stuff
    .description
       .
    .example
        PS>
    .outputs
          [string | None]

    #>
    # [Alias('a')]
    [
        OutputType([List[object]])
    ]
    [
                    CmdletBinding()
    ]
    param(
        # Piped foo
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]]$InputObject,

        <#
        For better semantics:
            - The name '$Options' always means the user-facing config
            - Internally all refernces use '$Config', not '$Options'
        $Options
            is the user-facing hashtable

            It is a free-form hashtable of addition arguments, allowing  extending features with minimal effort --  or complicating [ParametersSets]
        #>
        [               ArgumentCompletions('@{ ''Name'' = ''[␀]''')



                        ]
        [hashtable]$Option = @{}
    )
    begin {
        $Config = Ninmonkey.Console\Join-Hashtable -OtherHash $Option -BaseHash @{
            'SomeDefault' = $true
        }
        $items = [list[object]]::new()
    }
    process {
        $items.addRange($InputObject)
    }
    end {
        $items
    }
}
