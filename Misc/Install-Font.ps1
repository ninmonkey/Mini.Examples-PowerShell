#region functions
function Get-FontInfo {
    param(
        # Return dict
        [Parameter()]
        [switch]$PassThru
    )
    process {
        # some keys throw ErrorRecord
        #    CategoryInfo.Category == 'PermissionDenied'
        if ($PassThru) {
            $fontRegistryPaths = Get-ChildItem -ea Ignore -Recurse 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' | Where-Object { $_.PSPath -match 'font' }
            $fontRegistryPaths

            Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes\' -Name 'Helv' | Write-Verbose
            return
        }

        (Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink').Property
        | Join-String -sep ', ' -SingleQuote

        'from:'
        Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink'
        | Format-List
        Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontMapper'
        | Format-List

        Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontMapperFamilyFallback'
        | Format-List
        Get-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitute'
        | Format-List

        'registry paths'
        $fontRegistryPaths = Get-ChildItem -ea Ignore 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' | Where-Object { $_.PSPath -match 'font' }
        $fontRegistryPaths | Select-Object PSPath, PSChildName, ValueCount | Format-List
    }
}
function Install-Fonts {
    <#


    - [ ] I need to cleanup his code before release
    - [ ] does this make the font intraspectable for all apps?
    - [ ] needs shouldprocesses
    #>
    [cmdletbinding(SupportsShouldProcess, PositionalBinding = $false)]
    param (
        [alias('Font')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$Path
    )
    begin {
        $Dest_Filesystem = Get-Item -ea stop "$Env:LocalAppData\Microsoft\Windows\Fonts"
        $Dest_Filesystem_Global = Get-Item -ea Continue 'C:\Windows\Fonts'
        $Dest_Registry = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
    }

    Process {
        $FontObject = Get-Item -ea stop $Path
        try {
            $FontDestPath = Join-Path $Dest_Filesystem $FontObject.Name
            if (Test-Path $FontDestPath) {
                Write-Error "Font already exists: $FontDestPath"
                return
            }

            $template_ItemName = '{0} ({1})'
            $registryName = ''
            switch ($FontObject.Extension) {
                '.TTF' {
                    $registryName = $template_ItemName -f @(
                        $FontObject.BaseName,
                        'TrueType'
                    )
                    break
                }
                '.OTF' {
                    $registryName = $template_ItemName -f @(
                        $FontObject.BaseName,
                        'OpenType'
                    )
                    break
                }
                default {
                    Write-Error "Unknown font type: $FontObject"
                }
            }

            $metaDebug = [pscustomobject][ordered]@{
                Dest_Registry     = $Dest_Registry  | Join-String -SingleQuote
                Dest_Filesystem   = $Dest_Filesystem  | Join-String -SingleQuote
                FontDestPath      = $FontDestPath | Join-String -SingleQuote
                Source_FontObject = $FontObject | Join-String -SingleQuote
                registryName      = $registryName | Join-String -SingleQuote
            }
            $metaDebug | Format-List * | Out-String  | Write-Information
            if ($PSCmdlet.ShouldProcess($FontObject.FullName, 'Install Font')) {

                Copy-Item -Path $FontObject -Destination $FontDestPath -Force

                'Copied font: [{0}] -> [{1}]' -f @(
                    $FontObject,
                    $FontDestPath
                ) | Write-Host -fore green


                New-ItemProperty -Name $registryName -Path $Dest_Registry -PropertyType string -Value $FontObject.Name

                'Set Key: [{0}] -> [{1} = {2}]' -f @(
                    $Dest_Registry,
                    $registryName,
                    $FontObject.Name
                ) | Write-Host -fore green
            }
            Copy-Item -Path $FontObject -Destination $FontDestPath -Force

            # New-ItemProperty -Name $fn -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType string -Value $font
            # New-ItemProperty -Name $fn -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType string -Value $font
            # Copy-Item -Path $fontFile -Destination "C:\Windows\Fonts\$font" -Force
            # New-ItemProperty -Name $fn -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType string -Value $font
        }
        catch {
            Write-Warning $_.exception.message
        }
    }
    end {}
}


throw @'
    finish, and see

- [ ] better post: <https://jordanmalcolm.com/deploying-windows-10-fonts-at-scale/>
- [ ] check SO to verify it's the correct way to install font
- [ ] COM shell: https://www.powershellgallery.com/packages/PSWinGlue/0.3.3/Content/Functions%5CInstall-Font.ps1
- [ ] registr: https://powers-hell.com/2020/06/09/installing-fonts-with-powershell-intune/
- [ ] old answers here: https://stackoverflow.com/a/61035940/341744
- [ ] shouldprocess: https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.1#supportsshouldprocess
- [ ] When installed manually, the item property is not always the font name.
'@
# Get-FontInfo
$PathSrcFiraNerd = Get-Item -ea stop 'C:\Users\cppmo_000\Downloads\nerdfont variants\FiraCode'
$FontList = Get-ChildItem $PathSrcFiraNerd | Select-Object -First 2
# $FontList | Install-Fonts -Debug -ea break -infa Continue -WhatIf
$FontList | Install-Fonts -Debug -ea break -infa Continue
#endregion
