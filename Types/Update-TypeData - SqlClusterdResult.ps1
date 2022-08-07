Import-Module NameIt -ea stop

function Find-StandbyClusteredServers {
    <#
    .synopsis
        finds clustered stand-by SQL Servers
    .example
        PS> Find-StandbyClusteredServers
    .description
        This is an example to setup custom formatting and adds a summary property
        without using 'ps1xml' files, the type is declared inline.
    .link
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/update-typedata?view=powershell-7.3#description
    #>
    [CmdletBinding()]
    param()

    [object[]]$Clusters = @()
    $RoleType = 'SQL Server'

    # Get Clustered Stand-by SQL Servers
    try {
        # Capture which servers need to be patched
        # $Clusters = foreach ($c in (Connect-DbaInstance -SqlInstance $SqlInstances -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Where-Object IsClustered -EQ $true )) {

        #     # Capture the cluster FQDN
        #     $clusterName = Get-DbaWsfcCluster -ComputerName $c | Select-Object Fqdn;

        #     # Capture the list of Nodes in the cluster
        #     $Nodes = Get-DbaWsfcNode -ComputerName $clusterName.Fqdn | Select-Object Name, State;

        #     # Capture the current Owner Node
        #     $OwnerNode = Get-DbaWsfcResource -ComputerName $c | Where-Object Type -EQ $RoleType | Select-Object OwnerNode;

        #     # Capture the current Passive node
        #
        0..3 | ForEach-Object {
            # Create an object to hold the values
            [pscustomobject]@{
                PSTypeName  = 'eric.SqlClusterdResult'
                SqlInstance = 'svr.sql.instance-' + $_
                ClusterName = ig '[state]'
                OwnerNode   = ig '[person]'
                PassiveNode = ig '[color]'
                SomeGuid    = ig '####'
                LastUpdated = Get-Date
            }
        }
    } catch [SomeSpecificExceptionType] {
        Write-Warning "I handled this expected exception: $_"
    } catch {
        throw $_ # unexpected uncaught exception
    }
}

function initializeTypeData {
    $splatUpdateType = @{
        Force                     = $True
        TypeName                  = 'eric.SqlClusterdResult'
        DefaultDisplayPropertySet = 'SqlInstance', 'ClusterName', 'OwnerNode', 'LastUpdated', 'SomeGuid' # FL
        DefaultDisplayProperty    = 'WordDisplayString' # FW
        DefaultKeyPropertySet     = 'SqlInstance', 'ClusterName', 'SomeGuid'
    }
    Update-TypeData @splatUpdateType

    $splatUpdateType = @{
        Force      = $True
        TypeName   = 'eric.SqlClusterdResult'
        MemberType = 'ScriptProperty'
        MemberName = 'WordDisplayString'
        Value      = {
            '{0}@{1}.{2}' -f @(
                $This.SomeGuid
                $this.SQLInstance
                $this.ClusterName
            )
        }
    }
    Update-TypeData @splatUpdateType
}
. initializeTypeData
$results = Find-StandbyClusteredServers #-ea 'stop' # 'ignore' 'stop'

$results | Format-List
$results | Format-Table -AutoSize
$results | Format-Wide -Column 1

