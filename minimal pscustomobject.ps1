$About = @{
    Description = 'Setting "DefaultDisplayPropertySet" and "DefaultDisplayProperty" using Update-TypeData'
    Tags        = @('Update-TypeData', 'TypeData')
    Source      = ''
    Links       = @(
        'https://github.com/StartAutomating/EZOut/blob/master/Add-TypeData.ps1'
        'https://github.com/PowerShell/PowerShell/blob/master/src/System.Management.Automation/FormatAndOutput/DefaultFormatters/Help_format_ps1xml.cs'
        'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/update-typedata?view=powershell-7.1#example-2--update-types-multiple-times'
    )
    # RequiresVersion = '7.0'



}
<#
    minimal example of custom type formatting

refs

examples:


    [help_format_ps1xml are now cs files]<https://github.com/PowerShell/PowerShell/blob/master/src/System.Management.Automation/FormatAndOutput/DefaultFormatters/Help_format_ps1xml.cs>

    see more
        <https://github.com/StartAutomating/EZOut>
        <https://github.com/StartAutomating/EZOut/blob/master/Add-TypeData.ps1>

# Example: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/update-typedata?view=powershell-7.1#example-2--update-types-multiple-times>

        Update-TypeData -PrependPath TypesA.types.ps1xml, TypesB.types.ps1xml

    and
        $sb = {
            if ($this.Month -in @(1,2,3)) {"Q1"}
            elseif ($this.Month -in @(4,5,6)) {"Q2"}
            elseif ($this.Month -in @(7,8,9)) {"Q3"}
            else {"Q4"}
        }
        Update-TypeData -TypeName "System.DateTime" -MemberType ScriptProperty -MemberName "Quarter" -Value $sb
        (Get-Date).Quarter

        # ㏒: Q1

# Example: Default values used by List List by default

        Update-TypeData -TypeName "System.DateTime" -DefaultDisplayPropertySet "DateTime, DayOfYear, Quarter"
        Get-Date | Format-List
#>




function New-Animal {
    param(
        # species name
        [Parameter(Mandatory, Position = 0)]
        [string]$Species,

        # actual name
        [Parameter(Position = 1)]
        [string]$Name = 'unknown'
    )
    $hash = @{
        # Very long test to test wrapping
        ToTruncate = 'super long -- Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam dictum at arcu maximus commodo. Quisque pulvinar lobortis ligula. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;'
        Species    = $Species
        Age        = 2
        Name       = $Name
        Birth      = Get-Date
        PSTypeName = 'Animal'
    }
    [pscustomobject]$hash
}


$splat_UpdateTypeAnimal = @{
    TypeName                  = 'Nin.Animal'
    Force                     = $true
    DefaultDisplayPropertySet = @('Name', 'Species', 'Age')
    DefaultDisplayProperty    = 'Species'
    # 'DefaultKeyPropertySet' = '??'
}

Update-TypeData @splat_UpdateTypeAnimal -Force
# Update-TypeData
# Update-TypeData -TypeName "Nin.Animal" -Force -DefaultDisplayPropertySet "Name, Species, Age"

Get-Date | Format-List

## main test start

$splatLabelNote = @{
    'fg'  = 'gray60'
    'sep' = ''
}



$c = New-Animal 'cat'
$d = New-Animal 'dog' -Name 'Fred'

H1 'cat | Format-Wide'
Label @splatLabelNote 'should be just "species"'
$c | Format-Wide

H1 'cat'
Label @splatLabelNote 'should truncate even though it is not default params'
$c

H1 'cat | List'
Label @splatLabelNote 'should ingore truncate property'
$c | Format-List

Out-Default
H1 'dog, using FT'
Label @splatLabelNote 'should truncate even though it is not default params'
$d | Format-Table Name, ToTruncate, Species

# H1 'array'
# , @($c, $d) | TypeOf -FormatMode PSTypeNameList
H1 'typenames'
# H1 'no array'
# $c, $d | TypeOf PSTypeNameListls
