using namespace System.Collections.Generic

function InspectItemVersionInfo {
    <#
    .synopsis
        diff version info on two python items
    #>

    $SelectedBin = Get-Command python* -CommandType -All | Out-GridView -PassThru
    # select which
    $cmd = Get-Command python* -CommandType -All | Out-GridView -PassThru

    $cmd[0]
    | Select-Object -p $Props
    | to->Json -Depth 5 -EnumsAsStrings -AsArray
    | sc temp:\out1.json



    & 'code.cmd' @(
        '--diff'
  (Get-Item Temp:\out1.json)
  (Get-Item Temp:\out2.json)
    )

}

$p2 = 'HelpUri', 'FileVersionInfo', 'Version', 'Visibility', 'OutputType', 'CommandType', 'Module', 'RemotingCapability', 'ParameterSets'

return


# class Insect {
#     [string]$Name = 'anon'
#     [list[Insect]]$Kittens = [list[Insect]]::new()
# }

# class Horde {
#     [Insect]$SwarmLeader
#     [list[Insect]]$Coven = [list[Insect]]::new()
# }

# . { # InitializeHorde
#     $h ??= [Horde]::new()
#     0..4 | ForEach-Object {
#         $i = [Insect]::New()
#         $h.Coven.Add( $i  )
#     }

# }
