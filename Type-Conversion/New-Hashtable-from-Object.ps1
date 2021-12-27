#Requires -Version 7

function New-Hashtable {
    <#
    .synopsis
        Quickly create a hashtable from selected properties, filtered by regex
    .description
       .modes
        - default includes all properties
        - else declare properties. future: use regex to filter properties
        Afterwards, excludeproperty will optionally remove more
        - it does not use recursion
    .outputs
          [hashtable]
    #>
    [Alias(
        # 'To->Hashtable',
        'ConvertTo-Hashtable'
    )]
    [outputtype('hashtable')]
    param(
        # Source object
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # List of property names to keep
        [Parameter(Position = 0)]
        [string[]]$FilteredNames
    )

    $InputObject = Get-Item .
    $hash = @{}
    $filteredNames ??= $InputObject.PsObject.Properties.Name

    $filteredNames | ForEach-Object {
        $curName = $_
        # if ($InputObj.PsObject.Properties.Name -notcontains $curName) {
        #     Write-Error "Property not found: '$curName'"
        #     return
        # }
        try {
            $targetObj = $InputObject.psobject.properties
            $hash[ $curName ] = ($targetObj[ $curName ])?.Value
        } catch {
            Write-Error "Property not found: '$curName'"

        }
        # needs verbose null test if PS5

    }
    $hash
}


$exampleOutput = @'

PS> Get-Item . | New-Hashtable -FilteredNames 'Name', 'Directory'


Name                           Value
----                           -----
Directory
Name                           Powershell

PS> Get-Item . | New-Hashtable


Name                           Value
----                           -----
LastAccessTime                 12/27/2021 3:25:21 PM
Exists                         True
PSProvider                     Microsoft.PowerShell.Core\FileSystem
PSPath                         Microsoft.PowerShell.Core\FileSystem::C:\Users\cppmo_000\SkyDrive\Documents\2021\Powersh…
ModeWithoutHardLink            lar--
PSDrive                        C
CreationTime                   9/19/2021 3:30:00 PM
PSIsContainer                  True
LastWriteTime                  12/10/2021 3:36:43 PM
Root                           C:\
FullName                       C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell
PSChildName                    Powershell
Parent                         C:\Users\cppmo_000\SkyDrive\Documents\2021
Name                           Powershell
CreationTimeUtc                9/19/2021 8:30:00 PM
BaseName                       Powershell
Mode                           lar--
Target
LastAccessTimeUtc              12/27/2021 9:25:21 PM
Attributes                     ReadOnly, Directory, Archive, ReparsePoint
LinkTarget
Extension
PSParentPath                   Microsoft.PowerShell.Core\FileSystem::C:\Users\cppmo_000\SkyDrive\Documents\2021
LinkType
LastWriteTimeUtc               12/10/2021 9:36:43 PM
'@
