
Write-Warning 'Source: <https://discord.com/channels/180528040881815552/447476117629304853/842183004238905395>
'
function Invoke-NativeCommand {
    <#
    .SYNOPSIS
    A variant on invoke-command that allows you to easily handle errors
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #The command to execute
        [Parameter(Mandatory)][ScriptBlock]$Command,
        #What to do if something goes wrong. $PSItem will contain the error
        [ScriptBlock]$Catch,
        #What to run regardless of the result (usually used for cleanup)
        [ScriptBlock]$Finally
    )

    if (-not ($PSCmdlet.ShouldProcess($Command,'Invoking Native Command'))) { return }

    try {
        $result = & $Command 2>&1
        $result |
            Where-Object { $_ -is [ErrorRecord] } |
            ForEach-Object { throw $_ }
        $result
    } catch {
        if ($Catch) { . $Catch } else { throw $PSItem }
    } finally {
        if ($Finally) { . $Finally }
    }
}