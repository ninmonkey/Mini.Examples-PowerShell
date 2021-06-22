function prompt {
    # source: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts?view=powershell-7.2
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
        elseif ($principal.IsInRole($adminRole)) { '[ADMIN]: ' }
        else { '' }
    ) + 'PS ' + $(Get-Location) +
    $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

function prompt {
    # displays id number of commands:
    # The at sign creates an array in case only one history item exists.
    $history = @(Get-History)
    if ($history.Count -gt 0) {
        $lastItem = $history[$history.Count - 1]
        $lastId = $lastItem.Id
    }

    $nextCommand = $lastId + 1
    $currentDirectory = Get-Location
    "PS: $nextCommand $currentDirectory >"
}
