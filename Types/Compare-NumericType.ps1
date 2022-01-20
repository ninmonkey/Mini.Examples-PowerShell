#Requires -Version 7
using namespace System.Collections.Generic

function Compare-NumericType {
    <#
    .synopsis
        compare full type names, min, max, etc
    .example
        @(
            234
            2395563459
            [double]::MaxValue
        ) | Compare-NumericType

        # output:

                            Input Type                             Min                   Max IsPrimitive UnderlyingSystemType
                            ----- ----                             ---                   --- ----------- --------------------
            1.79769313486232E+308 System.Double -1.79769313486232E+308 1.79769313486232E+308        True System.Double
                                234 System.Int32             -2147483648            2147483647        True System.Int32
                        2395563459 System.Int64    -9223372036854775808   9223372036854775807        True System.Int64
    #>
    param(
        # input as any type
        [parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject
    )
    begin {
        $numList = [List[object]]::new()
    }
    process {
        $numList.AddRange( $InputObject )
    }
    end {
        $numList
        | ForEach-Object {
            $tinfo = $_.GetType()
            [pscustomobject]@{
                'Input'                = $_
                'Type'                 = $tinfo
                'Min'                  = $tinfo::MinValue
                'Max'                  = $tinfo::MaxValue
                'IsPrimitive'          = $tinfo.IsPrimitive
                'UnderlyingSystemType' = $tinfo.UnderlyingSystemType
            }

        } | Sort-Object Type
    }
}
