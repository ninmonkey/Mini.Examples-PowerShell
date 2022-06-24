<#
2022-04
https://discord.com/channels/180528040881815552/447476117629304853/961693518559064094
https://xkln.net/blog/multithreading-in-powershell--running-a-specific-number-of-threads/
#>

$PCs = 'my', 'list', 'of', 'names'

$script = @'
param (
    [string]$ComputerName,

    [PSCredential]$Credential
)

Test-WSMan -ComputerName $ComputerName -Credential $Credential
'@

$runspacePool = [RunspaceFactory]::CreateRunspacePool(1, 30)
$runspacePool.Open()
$jobs = $PCs | ForEach-Object {
    $instance = [PowerShell]::Create().AddScript(
        $script
    ).AddParameter(
        'ComputerName',
        $_
    ).AddParameter(
        'Credential',
        $Credential
    )
    $instance.RunspacePool = $runspacePool
    [PSCustomObject]@{
        Id          = $instance.InstanceId
        Instance    = $instance
        AsyncResult = $instance.BeginInvoke()
    } | Add-Member State -MemberType ScriptProperty -PassThru -Value {
        $this.Instance.InvocationStateInfo.State
    }
}
