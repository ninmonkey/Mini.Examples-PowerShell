$WHatIf = $True

function Invoke-Subinacl {
    param(
        [switch]$WhatIf
    )
    $binCmd = Get-Command -CommandType Application -Name 'subinacl' | Select-Object -First 1

    if (! $binCmd ) {
        Throw 'failed to find binary'
    }

    $ErrLog = Get-Item -ea stop 'c:\temp\errorlog.txt'
    $OutputLog = Get-Item -ea stop 'c:\temp\outputlog.txt'
    $ScriptPath = Get-Item -ea stop 'E:\scripts'

    $subArgs = @(
        '/errorlog="{0}"' -f $ErrLog.FullName
        '/outputlog="{0}"' -f $OutputLog.FullName
        '/file'
        $ScriptPath
        '/setowner=subhro\awsadmins'
    )
    if ( $Whatif ) {
        @(
            'Running:'
            $binCmd.Name
            'With args'
            $subArgs -join ' '
        ) -join ' '
        return
    }
    & $BinCmd @subArgs
}

Invoke-Subinacl -WhatIf
