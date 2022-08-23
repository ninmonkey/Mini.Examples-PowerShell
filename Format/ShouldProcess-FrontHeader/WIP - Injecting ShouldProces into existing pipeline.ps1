function Test-ShouldProcess {
    <#
    .synopsis
        Inject should-process into a pipeline, or test formatting of ShouldProcess
    .description
       the extra boilerplate is more of a documentation than useful item
       different hosts on the same machine can/will render shouldprocess and shouldconfirm, differently
    .notes
        Types involved:

            > [ShouldProcessReason] | Get-EnumInfo

            Enum: System.Management.Automation.ShouldProcessReason

            Value Name                      Hex        Bits
            ----- ----                      ---        ----
                0 None                      0x0        0000.0000
                1 WhatIf                    0x1        0000.0001

        Expected Exceptions:
            ShouldContinue:
                [PipelineStoppedException], [InvalidOperationException]

            ShouldProcess
                [PipelineStoppedException], [InvalidOperationException]

        todo future:
            The param ([int]$TestMode) can be used to autcomplete remaining args in the set
    .link
        https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldprocess?view=powershellsdk-7.0.0
    .link
        https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldcontinue?view=powershellsdk-7.0.0
    .example
          PS>  'hi', 'world' | Test-ShouldProcess
    .outputs
          [string | None]

    #>
    [Alias('?ShouldProcess')]
    [CmdletBinding(
        # SupportsPaging # future: paging should probably be split out
        ConfirmImpact = 'High', PositionalBinding = $false, SupportsShouldProcess)]
    param(
        # whether to use one condition for the the full pipeline, or iterate on every one
        [Parameter(ParameterSetName = 'TestEachItem')]
        [switch]$TestEachItem = $false,

        # mode? : until these are refactored to two commandlets, mode is set here
        [Alias('Type')]
        [parameter()]
        [validateset('ShouldProcess', 'ShouldConfirm')]
        [string]$ShouldProcessType = 'ShouldProcess',

        # which overload
        [Parameter()]
        [int]$TestMode = 1,

        # test colors with ansi escapes
        [Parameter()]
        [switch]$Colorize,

        # docstring like info dump
        [Alias('Describe')]
        [Parameter()]
        [switch]$Help

    )

    begin {
        if ($Help) {
            '
            - [cmdlet.shouldprocess](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldprocess?view=powershellsdk-7.0.0)
            - [cmdlet.shouldcontinue](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.cmdlet.shouldcontinue?view=powershellsdk-7.0.0)
            '
        }
        if ($Colorize) {
            Write-Error -Category NotImplemented -m 'NYI: -Colorize'
        }
        function _handleShouldProcess {
            param(
                [Parameter(Mandatory, Position = 0)]
                [int]$TestMode

            )
            $ProcessMode = $TestMode
            [string]$Target = 'Target'
            [string]$Action = 'Action'
            [ShouldProcessReason]$Reason = [ShouldProcessReason]::WhatIf # or [ShouldProcessReason]::None
            switch ($ShouldProcessMode) {
                1 {
                    if ($PSCmdlet.ShouldProcess(
                            <# target: #> $target)) {

                    }
                }
                2 {
                    if ($PSCmdlet.ShouldProcess(
                            <# target: #> $target,
                            <# action: #> $action)) {
                    }

                }


                3 {
                    if ($PSCmdlet.ShouldProcess(
                            <# verboseDescription: #> $verboseDescription,
                            <# verboseWarning: #> $verboseWarning,
                            <# caption: #> $caption)) {

                    }
                }
                4 {

                    if ($PSCmdlet.ShouldProcess(
                            <# verboseDescription: #> $verboseDescription,
                            <# verboseWarning: #> $verboseWarning,
                            <# caption: #> $caption,
                            <# shouldProcessReason: #> $reason)) {

                    }
                }
                default {

                }
            }
        }

        function _handleShouldConfirm {
            param(
                [Parameter(Mandatory, Position = 0)]
                [int]$TestMode

            )
            $ShouldContinueMode = $TestMode

            # types:
            [string]$Query = 'Query'
            [string]$Caption = 'caption'
            [bool]$hasSecurityImpact = $false
            [bool]$yesToAll = 'YesToAll'
            [bool]$noToAll = 'noToAll'

            switch ($ShouldContinueMode) {
                1 {
                    if ($PSCmdlet.ShouldContinue(
                            <# query: #> $query,
                            <# caption: #> $caption)) {

                    }
                }
                2 {
                    if ($PSCmdlet.ShouldContinue(
                            <# [string] query: #> $query,
                            <# [string] caption: #> $caption,
                            <# [bool] yesToAll: #> $yesToAll,
                            <# [bool] noToAll: #> $noToAll) ) {

                    }
                }
                3 {

                    if ($PSCmdlet.ShouldContinue(
                            <# query: #> $query,
                            <# caption: #> $caption,
                            <# hasSecurityImpact: #> $hasSecurityImpact,
                            <# yesToAll: #> $yesToAll,
                            <# noToAll: #> $noToAll) ) {
                    }

                }
                default {}
            }
        }
    }
    # process {} #declaring will automatically exhaust '$Input'
    end {
        # function _parseResult {

        # }
        Write-Warning 'still very wip'
        function _processAsk {
            # minimacros
            if ($ShouldProcessType -eq 'ShouldProcess') {
                $answer = _handleShouldProcess
            } else {
                $answer = _handleShouldConfirm
            }
            $answer
        }
        function _testOnce {
            $Answer = _processAsk
            if ($Answer) {
                $Input
            }
        }
        function _testEachItem {
            $input | Where-Object {
                $Answer = _processAsk
                $Answer;
            }
        }

        if (! $TestEachItem) {
            Write-Debug 'TestOnce'
            _testOnce
        } else {
            Write-Debug 'TestEachItem'
            _testEachItem
        }
        return
        # $PSCmdlet | Get-HelpFromTypeName

    }
}


# 0..1 | Where-Object {
#     Test-ShouldProcess -mode 1
# }