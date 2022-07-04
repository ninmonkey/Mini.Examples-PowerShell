
# # this runs
# function unwise {
#     param( [string]$Label )
#     process {
#         $Input | Join-String -op "${Label}: "
#     }
# }

Write-Warning "!! '$PSCommandPath' : need to extract as a module !!"

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
        if (($tinfo = $InputObject -as 'type')) {
            return $tinfo
        }

    }
}
function nb.resolveModuleInfo {
    <#
    .synopsis
        Resolves names to a [PSModuleInfo]
    .DESCRIPTION
        First attempt to get module info with the current imports
        If that fails, then import the module
    #>
    # Resolve->ModuleInfo
    [Alias('nb.Resolve->Module')]
    [OutputType('Management.Automation.PSModuleInfo')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject # don't even need by value, it auto coerces
    )
    begin {
    }
    process {
        $target = $InputObject
        if ($Target -is 'Management.Automation.PSModuleInfo') {
            return $Target
        }
        $Text = $InputObject
        if (($target = Get-Module $text -ea ignore )) {
            return $target
        }
        Import-Module $InputObject -Scope Global -
        | Write-Debug # should it be silentsilent ?
        # $info =

        Get-Module -Name $Target
    }
    end {
    }
}

function _fmt_moduleVersion {
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [psmoduleinfo[]]$ModulesUsed # don't even need by value, it auto coerces
    )
    begin {
        $modulesList = [Collections.Generic.List[object]]::new() # // object
    }
    process {
        $modulesList.AddRange( $ModulesUsed )
    }
    end {
        $ModulesList | ForEach-Object {
            Get-Module $_ | Join-String {
                $_.Name, $_.Version.ToString() -join ' '
            }
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
    'Generated using Pwsh: {0}' -f @(
        $PSVersionTable.PSVersion.ToString()
    )
    'List Imported Modules: {0}' -f @(
        Get-Module | _fmt_moduleVersion
    )
}
# nb.ImportModule 'ClassExplorer'
nb.ImportModule @(
    'ClassExplorer'
    'PowerHTML'
    # 'ninmonkey.console'
    # 'dev.nin'
)

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