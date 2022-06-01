function icmsomething {
    <#
        from: @santisq <https://discord.com/channels/180528040881815552/447476117629304853/962118670044233769>
    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string] $Command,
        [parameter(ValueFromRemainingArguments)]
        [string[]] $Arguments,
        [parameter()]
        [string[]] $ComputerName = $env:COMPUTERNAME
    )

    Invoke-Command { & $using:Command @using:Arguments } -ComputerName $ComputerName
}

icmsomething ping 8.8.8.8
