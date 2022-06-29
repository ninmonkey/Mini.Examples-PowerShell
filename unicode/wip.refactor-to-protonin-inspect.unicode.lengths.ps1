function InspectUniLength {
    <#
    .SYNOPSIS
        inspect counts and lengths of unicode measurements
    #>
    [cmdletBinding()]
    param(
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String]$InputObject,

        # return hashtable verses an object
        [switch]$AsHashtable
    )
    process {



        $str = $InputObject
        $dbg = [ordered]@{
            Source      = $str
            SourceColor = "'${fg:green}${fg:gray80}${bg:gray30}${str}${fg:clear}${bg:clear}'"
            NumChars    = $str.Length
            '.Length'   = $str.Length
            '.Count'    = $str.count
        }

        if ($PassThru) {
            return [pscustomobject]$dbg
        } else {
            return $dbg
        }
    }
}


$StrSample = @{
    'Family'     = '👨‍👩‍👧‍👦'
    'Man'        = '1👨'
    'Ascii'      = 'zbfdef'
    'WhiteSpace' = ''
}

$StrSample.Man | InspectUniLength -AsHashtable
Hr
$StrSample.Man | InspectUniLength
Hr
$StrSample.Ascii | InspectUniLength
Hr
$StrSample.Family | InspectUniLength

function ConvertTo-UnicodeBytes {
    <#
    .SYNOPSIS
        Sugar to encode/decode

        gcm -Module PSFramework *completion*, *completer* | % Name
    .link
        PSFramework\New-PSFTeppCompletionResult
    .link
        PSFramework\Register-PSFTeppArgumentCompleter

    #>
    [Alias('StrToBytes')]
    [OutputType('[System.Byte[]]')]
    [cmdletBinding()]
    param(
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String[]]$InputObject,

        # return hashtable verses an object
        [switch]$AsHashtable
    )
    process {
        $InputObject | ForEach-Object {
            $curLine = $_


        }
        return 'sdf'
    }
}
function ConvertFrom-UnicodeBytes {
    <#
    .SYNOPSIS
        Sugar to encode/decode
    #>
    [Alias('StrFromBytes')]
    [cmdletBinding()]
    param(
        [Alias('Bytes')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String]$InputObject,

        # return hashtable verses an object
        [switch]$AsHashtable
    )
}
