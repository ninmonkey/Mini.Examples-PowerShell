$APP_PATH_ROOT = Get-Item -ea stop $PSScriptRoot
$APP_PATH_ROOT = Get-Item 'C:/nin_temp/formatdata/' -ea stop

function _exportFormatData {
    <#
    .synopsis
        export formatting and generate file to load from if not existing
    #>
    param(
        # typename
        [Parameter(mandatory, valuefromPipeline)]
        [string]$TypeName
    )

    $SubDir = 'format.ps1xml'
    Write-Verbose "Type: '$TypeName'"
    if (! (Test-Path "$APP_PATH_ROOT\$SubDir")) {
        New-Item -Path "$APP_PATH_ROOT\$SubDir" -ItemType Directory
        # throw 'folder'
    }
    $Path_Original = "$APP_PATH_ROOT\$SubDir\format-$TypeName.ps1xml"
    $Path_Custom = "$APP_PATH_ROOT\$SubDir\format-$TypeName-nin.ps1xml"
    $Fd = Get-FormatData -TypeName $TypeName -PowerShellVersion 7.1 #-PowerShellVersion 5.1

    if ($fd) {
        if (! (Test-Path $Path_Original) ) {
            Write-Verbose "New type, creating: '$Path_Original'"
            # you don't want to export the modified version if already existing
            Export-FormatData -InputObject $Fd -Path $Path_Original -IncludeScriptBlock
        }
    } else {
        #         Label TypeNameNotFound $TypeName -fg orange
        Write-Error "TypeNameNotFound: $TypeName"
    }

    if (! (Test-Path $Path_Custom) ) {
        Write-Verbose "New type, creating: '$Path_Custom'"
        Copy-Item -Path $Path_Original -Destination $Path_Custom
    }
    $customFormat = Get-Item -ea stop $Path_Custom
    Update-FormatData -PrependPath $customFormat
    Write-Verbose 'success'
}

$typeList = @(
    'Microsoft.Management.Infrastructure.CimInstance'
    'System.RuntimeType'
    'System.IO.FileInfo'
    'System.IO.DirectoryInfo'
    'System.IO.FileSystemInfo'
    'System.Management.Automation.ScriptBlock'
    'System.Management.Automation.FunctionInfo'
) | Sort-Object -Unique

$typeList = Find-Type *Ast* | ForEach-Object FullName | Sort-Object -Unique

foreach ($name in $typeList) {
    _exportFormatData $name -Verbose -ea Ignore -Debug -infa Continue
}
