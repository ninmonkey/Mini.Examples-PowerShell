function Get-HelpFromType {
    <#
    .synopsis
        open Powershell docs from a type name
    .example
        PS> HelpFromType int64
    .example
        PS> [System.Management.Automation.ErrorRecord] | Get-HelpFromType
    .example
        PS> (Get-Command ls) | HelpFromType
        # Loads docs on [AliasInfo]
        # <https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.AliasInfo?view=powershellsdk-7.0.0>
    #>
    [Alias('TypeHelp', 'HelpFromType')]
    param(
        # object or type instance, should auto coerce to FullName
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # Return urls instead of opening browser pages
        [Parameter()][switch]$PassThru
    )

    process {
        if ($InputObject -is [string]) {
            $typeInstance = $InputObject -as [type]
            if ($null -eq $typeInstance) {
                Write-Debug "String, was not a type name: '$InputObject'"
                $typeName = 'System.String'
            }
            else {
                $typeName = $typeInstance.FullName
            }
        }
        elseif ( $InputObject -is [type] ) {
            $typeName = $InputObject.FullName
        }
        else {
            $typeName = $InputObject.GetType().FullName
        }
        $url = 'https://docs.microsoft.com/en-us/dotnet/api/{0}' -f $typeName

        if ($PassThru) {
            $url
            return
        }
        Start-Process $url
    }
}
