$splat = @{
    'ea'          = 'Ignore'
    'CommandType' = 'Application'
}
# function Resolve-VSCodeVenv {
function Invoke-VSCodeVenv {
    param(
        # Render command,
        [switch]$WhatIf
    )
    # .cmd version is automaticaly the right priority, but just in case
    # go explicit
    $query = @(
        if ($ForceInsider) {
            'code-insiders.cmd'
            'code-insiders'
        }
        # else the default may be code
        'c:\vscode_env\...\code'
        'code.cmd'
        'code'
        'code-insiders.cmd'
    )
    $resolvedBin = $query | Select-Object -First 1
    # Code-vEnv -CodeBinPath code -AddonDir J:\vscode_datadir\code-dev-addons

    # the '@()' operator is fun, you can use optional logic
    # to
    $VSCodeArgs = @(
        if ($NewWindow) {
            '--new-window'
        } else {
            '--reuse-window'
        }

        # sometimes it's better to use ignore (or silentlyContinue)
        # this will silently resolve back to the usur's global data dir
        # if it's not specified
        $customDataDir = Get-Item -ea silentlyContinue $UserDataDir
        if ($customDataDir) {
            '--user-data-dir'

            $customDataDir
            | Join-String -DoubleQuote
        }

        # Other times you want inline errors to be fatal for required files
        '--goto'
        Get-Item 'c:\doest\not\exist\bar.txt' -ea 'Stop'
        | Join-String -DoubleQuote
    )

    $meta = @{
        'ForceInsider' = $ForceInsider
        'Resolved'     = $resolvedBin
    }
    $renderFinalString = $VSCodeArgs
    | Join-String -sep ' ' -op $resolvedBin.FullName

    $joinstringSplat = @{
        Separator    = "`n"
        DoubleQuote  = $true
        OutputPrefix = "results = [`n"
        OutputSuffix = ']'
        Property     = 'FullName'
        FinalCommand = $a
    }


    $query | Join-String @joinstringSplat | Write-Debug
    $VSCodeArgs | Join-String -sep ' ' -op $resolvedBin.FullName
    # | Write-Information

    if ( $WhatIf ) {
        return
    }

    # & $resolvedBin @VSCodeArgs or it's cleaner to use start-process
}
# select -first 1
Code-vEnv -Whatif -CodeBinPath 'code' -infa continue
Code-vEnv -Whatif -CodeBinPath 'code' -AddonDir J:\vscode_datadir\code-dev-addons -infa continue
