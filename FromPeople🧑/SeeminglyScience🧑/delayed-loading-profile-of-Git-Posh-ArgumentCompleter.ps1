<#
https://discord.com/channels/180528040881815552/447476164232216576/984116701606055996

seeminglyscience — Yesterday at 10:28 AM
any time I lazily init a type in my profile the first run is an extra like 2-5 seconds
btw, I know you want the prompt as well, but if you ever decide that the tab completion is good enough here's what I do:

still get completion after you run git at least once

#>
function Invoke-Git {
    [Alias('git')]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]] $ArgumentList
    )
    begin {
        Import-Module posh-git -Global
        $command = $ExecutionContext.SessionState.InvokeCommand.GetCommand(
            'git',
            [CommandTypes]::Application)

        $pipe = { & $command @ArgumentList }.GetSteppablePipeline($MyInvocation.CommandOrigin)
        $pipe.Begin($PSCmdlet)
    }
    process {
        $pipe.Process($PSItem)
    }
    end {
        $pipe.End()
    }
}