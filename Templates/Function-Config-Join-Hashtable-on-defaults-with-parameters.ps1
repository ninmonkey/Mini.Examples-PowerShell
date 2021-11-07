function Verb-Noun {
    <#
        .synopsis
            .
        .notes
            .
        .example   
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]InputObject, 
    
        # extra options
        [Parameter()][hashtable]Options
    )
    begin {
        [hashtable]ColorType = Join-Hashtable ColorType (Options.ColorType ?? @{})       
        [hashtable]Config = @{
            AlignKeyValuePairs = true
            Title              = 'Default'
            DisplayTypeName    = true
        }
        Config = Join-Hashtable Config (Options ?? @{})        
    }
    process {}
    end {}
}