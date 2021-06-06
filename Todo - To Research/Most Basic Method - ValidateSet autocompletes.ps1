function Invoke-App {
    <#
    .synopsis
        Auto complete app names to execute
    #>
    param(
        # AppName
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('PowerShell', 'ADAC', 'MMC', 'NetScan', 'DameWare', 'RDP', 'Control Panel', 'SSMS', 'Visual Studio 2019')]
        [string]$AppName
    )

    "Run: $AppName"
}
