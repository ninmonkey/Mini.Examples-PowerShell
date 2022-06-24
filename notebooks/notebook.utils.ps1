
# # this runs
# function unwise {
#     param( [string]$Label )
#     process {
#         $Input | Join-String -op "${Label}: "
#     }
# }

# 0..4 | unwise -Label 'Int list'
$Uni = @{
    NullStr = "[`u{2400}]"
}
function nb.resolveTypeInfo {
    # resolves Typename
    [Alias('nb.Resolve->Type')]
    [OutputType('System.Type')] # ??
    [CmdletBinding()]
    param(
        # pipe any type, it will call GetType() for you
        [AlloWNull()]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject
    )
    process {
        return $Null
        if ($Null -eq $InputObject) {
            return
        }
        if ($InputObject -is 'type') {
            return $InputObject
        }
        if (($tinfo = $IputObject -as 'type')) {
            return $tinfo
        }

    }
}
function nb.resolveModuleInfo {
    # Resolve->ModuleInfo
    [Alias('nb.Resolve->Module')]
    [OutputType('PSModuleInfo')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject # don't even need by value, it auto coerces
    )
    process {
        $target = $InputObject
        if ($Target -is 'PSModuleInfo') {
            return $Target
        }
        $Text = $InputObject
        if (($target = Get-Module $text -ea ignore )) {
            return $target
        }
        Import-Module $InputObject
        $info =

        Get-Module -Name $Target
    }
    # 'Ninmonkey.Console' | _as_moduleInfo
}

function _fmt_moduleVersion {
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [PSModuleInfo[]]$ModulesUsed # don't even need by value, it auto coerces
    )
    process {
        $ModulesUsed | ForEach-Object {
            Get-Module $_ | Join-String { $_.Name, $_.Version.ToString() -join ' ' }
        } | Join-String -sep ', '
    }
}
function nb.ImportModule {
    param(
        [string[]]$ModuleNames
    )
    Import-Module -Name $ModuleNames -Scope Global -PassThru
    | Sort-Object Name
    | _fmt_moduleVersion
    | Join-String -op 'ImportModules: '
}
function nb.ListVersions {
    $ModulesUsed = @('ClassExplorer')
    'Generated using Pwsh: {0}{1}' -f @( $PSVersionTable.PSVersion.ToString()

    )
}
nb.ImportModule 'ClassExplorer'

$ec = $ExecutionContext
$sess = $ExecutionContext.SessionState

'Created refs: $ec (Execution Context) $sess (Session State)'
'Created Functions: ...'
'Imported Modules: '

return

# function fmStr {
#     # because: Out-String always ignores PSDefaultparametervalues
#     $Input | Find-Member | Format-Table Name, DisplayString | Out-String -Width 500
# }
# function joinCsv {
#     $Input | Join-String -sep ', '
# }
# function _resolveType
# function typeIs {
#     # $Obj = $Input # to save space, from writing a correct function
#     param(
#         [Parameter(ValueFromPipeline, Mandatory, Position = 0)]$InputObject
#     )
#     process {
#         function _renderType {
#             $Tinfo = $InputObject.GetType()
#             $Tinfo
#             | Join-String -op '[' -os ']' { $_.FullName -replace '^System\.', '' }
#             | Join-String -os (' len: {0}' -f $InputObject.Count)

#         }
#         $Tinfo = $InputObject.GetType()
#         $Tinfo
#         | Join-String -op '[' -os ']' { $_.FullName -replace '^System\.', '' }
#         | Join-String -os (' len: {0}' -f $InputObject.Count)

#         $InputObject.PSTypeNames | ForEach-Object { $_ -as 'type' }
#         | Join-String -op '[' -os ']' -sep ', ' { $_.FullName -replace '^System\.', '' }
#         | JoinCsv
#     }
# }

# TypeIs (0..4)
# TypeIs (Get-Item . )