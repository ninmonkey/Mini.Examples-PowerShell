Write-Warning 'This file has a million of errors on purpose -- so you can compare what color-errors look like. '
& {
    $ErrorActionPreference = 'Continue'
    function relEnv {


        $Env:USERPROFILE, $Env:LOCALAPPDATA, $Env:APPDATA | Sort-Object -des
    ($Object).?

        $ninEnv = Get-ChildItem env:
        | Where-Object { $_.Value -Match 'c:' -or (Test-Path $_.Value) }
        | Sort-Object value | ForEach-Object {
            # order by lenght of most-possible-replaced-text
            $accum = $accum -replace (RelIt $Env:LocalAppData), '$Env:LocalAppData'
            | Join-String -op "${bg:gray30}" -os $PSStyle.Reset

            $accum = $accum -replace (RelIt $Env:AppData), '$Env:LocalAppData'
            $accum = $accum -replace (ReLit $Env:UserProfile), '$Env:UserProfile'

            $here = @'
here-single`n`n``ffdsj`
'@
            $here = @"
literal completely
here-double`bf`n`n`t ```nds
$Name: `n`n

    $Name.woof
$(  $Name.woof  )
    $($Name.woof)
    $($Name.woof(1,2,3))
"@
            Get-Item "$env:AppData\Code - Insiders\User\History"
            hi 'dsf`dsff 4s'
            "fds `dffds"

            function ? {
                $Input * 2
            }
            $x ??= @{ a = 2; 'b' = 3; 'f' = { 3 } } ?? (throw $fg:Redf fs)
            $true ?? (throw $fg:Redf fs)
            $true ?? (throw $fg:\Red fs)
            $true ?? (throw '$fg:\Red' fs)
            $true ?? (throw "$fg:\Red" fs)

            $null -eq '324'
            $null ?? $null ?? $null.count
        ($foo)?.tostring()
        ($foo)?['bar']
        ($foo)?.'bar'

            $accum -replace '(SkyDrive/Documents)', "${fg:gray40}docs:${fg:gray60}"

            # my provider underlineapplies, but it's missing a bunch of customizations
            # you can tell whether it's parsing as
            # the variable $name, a or a scope
            " ${Name}: Is Fido"
            " $Name: Is Fido"
            " $Name:Is Fido"   # or as a provider
            "${fg:Green}Success Message${fg:Clear}"

            "${fg:GreenSuccess Message${fg:Clear}"  # error
            "$fg:GreenSuccess Message${fg:Clear}"  # runs but uses a bad path
            "$fg:Green $($fg:orange) ...${fg:Clear} "

            Get-Item "$env:AppData\Code - Insiders\User\History"

            $script:bar = 30
            $script:bar = 30
            $global:dog = 32

            $script.state = 'title'
            $script.score = 0
            [pscustomobject]@{
                Key   = $_.Key
                Value = $_.Value
                Len   = $_.Value.Length
                Short = $cleanVal
            }
        }
        $ninEnv
        # to update
    }
    $res = relEnv; $res | Format-Table Key, Short, Value -AutoSize
    $res | Select-Object -Last 3 | Format-List

}