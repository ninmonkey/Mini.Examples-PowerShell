<#

from <https://github.com/Jaykul>
About:
    This version captures output stream using a logging module

#>

Import-Module PowerShellLogging -MinimumVersion 1.4.0
$whatif = [System.Collections.ArrayList]::new()
$subber = Enable-OutputSubscriber -OnWriteOutput { $whatif.Add($args[0].Trim()) }
$source = 'C:\Users\Jaykul\OneDrive - PoshCode\Documents\PowerShell\Modules\PowerShellLogging\'
Get-ChildItem $source -Recurse | Copy-Item -dest $pwd -WhatIf
Disable-OutputSubscriber $subber
$whatif -replace ".*the operation `"([^`"]+)`" on target `"Item: $([regex]::escape($source))(.*) Destination: (.*)`"", "${fg:Cyan}WhatIf: $fg:DarkCyan`$1 $fg:Yellow`$2 $fg:magenta-> $fg:Green`$3"
