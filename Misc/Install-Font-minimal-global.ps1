
$FontItem = Get-Item -ea stop -Path 'C:\Users\cppmo_000\Downloads\nerdfont variants\FiraCode'
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon', '*.otf', '*.ttc', '*.ttf')

foreach ($Font in $FontList) {
    Write-Host 'Installing font -' $Font.BaseName
    Copy-Item $Font 'C:\Windows\Fonts'
    New-ItemProperty -Name $Font.BaseName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType string -Value $Font.name
}
