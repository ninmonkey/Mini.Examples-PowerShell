using namespace System.Collections.Generic

<#
output:

    Warning |         svchost | 2022-05-11T14:21:15.5686541-05:00
    Warning |         svchost | 2022-05-11T14:21:15.5692105-05:00
    Warning |         svchost | 2022-05-11T14:21:15.5695103-05:00
    Warning |   RuntimeBroker | 2022-05-11T14:21:15.5698410-05:00
    Warning |            Code | 2022-05-11T14:21:15.5701861-05:00
    Warning |         svchost | 2022-05-11T14:21:15.5704828-05:00
    Warning |   RuntimeBroker | 2022-05-11T14:21:15.5707776-05:00
    Warning |         firefox | 2022-05-11T14:21:15.5710803-05:00
    Warning |  steamwebhelper | 2022-05-11T14:21:15.5714494-05:00
    Warning |      SgrmBroker | 2022-05-11T14:21:15.5717404-05:00
    -------------------------------------------------------------
    Verbose | svchost         | 2022-05-11T14:21:15.5855295-05:00
    Verbose | sqlwriter       | 2022-05-11T14:21:15.5860031-05:00
    Verbose | slack           | 2022-05-11T14:21:15.5864755-05:00
    Verbose | svchost         | 2022-05-11T14:21:15.5868773-05:00
    Verbose | Wacom_TouchUser | 2022-05-11T14:21:15.5872515-05:00
    Verbose | firefox         | 2022-05-11T14:21:15.5876632-05:00
    Verbose | Spotify         | 2022-05-11T14:21:15.5880274-05:00
    Verbose | GameBarFTServer | 2022-05-11T14:21:15.5883796-05:00
    Verbose | svchost         | 2022-05-11T14:21:15.5887656-05:00
    Verbose | svchost         | 2022-05-11T14:21:15.5891306-05:00

#>

function _writeRecord {
    # write one record
    param(
        [ValidateSet('default', 'inverse')]
        [string]$TemplateName = 'default',

        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Message,

        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('Error', 'Warning', 'Verbose', 'None')]
        [string]$Severity,


        # if defined, override template
        [Parameter()]
        [ArgumentCompletions("'{0,6} | {1,15} | {2}'")]
        [string]$FormatString
    )
    begin {
        $logTemplate = @{
            default = '{0,6} | {1,-15} | {2}'
            inverse = '{0,6} | {1,15} | {2}'
        }
        $template = $FormatString ? $FormatString : $logTemplate.$TemplateName
        $Lines = [List[string]]::new()
    }
    process {
        if ( [string]::IsNullOrWhiteSpace($Message) ) {
            return
        }
        $Lines.Add( $Message )
    }
    end {
        $Lines | ForEach-Object {
            $Message = $_
            $Template -f @(
                $Severity
                $Message
                (Get-Date).ToString('o')
            )
        }
    }
}

Get-Process | Get-Random -Count 10 | ForEach-Object Name
| _writeRecord Warning -TemplateName inverse

Hr

Get-Process | Get-Random -Count 10 | ForEach-Object Name
| _writeRecord Verbose -TemplateName default
