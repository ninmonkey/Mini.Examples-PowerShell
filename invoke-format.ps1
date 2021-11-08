
# Write-Warning 'Source: <https://discord.com/channels/180528040881815552/447476117629304853/842183004238905395>
# '
# $src = Get-Item -ea stop (Join-Path $PSScriptRoot 'Invoke-NativeCommand - justin.grote.ps1')

# Invoke-ScriptAnalyzer -Path $src
# hr
# Invoke-Formatter -ScriptDefinition (Get-Content -Raw $src )
# $result |
#     Where-Object { $_ -is [ErrorRecord] } |
#     ForEach-Object { throw $_ }
