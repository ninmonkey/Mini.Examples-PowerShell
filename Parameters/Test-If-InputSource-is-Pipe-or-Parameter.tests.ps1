Describe 'Test-InputSource' {
    BeforeAll {
        function Test-InputSource {
            <#
            .synopsis
                Detect if $InputObject[] is from pipeline or a param,By using 'DefaultParameterSet', 'Mandatory', and 'ParameterSetName
            .description
                - 'DefaultParameterSet' is the one that is *not* from pipeline
                - therefore if the is set, it cannot be from a parameter
                - Mandatory forces it to the other parameter set
                - plus, you can use a positional parameter a 0, without needing to use a parameter

            alternate:
                - you could also check whether 'end {}' is called but 'process {}' was not
            #>
            [CmdletBinding(
                DefaultParameterSetName = 'FromParam',
                PositionalBinding = $false)]
            param(
                [Parameter(Mandatory, Position = 0, ParameterSetName = 'FromParam')]
                [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromPipe')]
                [object[]]$InputObject,

                # I picked the color enum so you can verify autocomplete with no-param-passing is needed
                [Parameter(Position = 1, ParameterSetName = 'FromParam')]
                [Parameter(Position = 0, ParameterSetName = 'FromPipe')]
                [System.ConsoleColor]$Color
            )

            begin {}
            process {
                switch ($PSCmdlet.ParameterSetName) {
                    'FromParam' {
                        'Param'
                    }
                    'FromPipe' {
                        'Pipe'
                    }
                    default { throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)" }
                }
            }
            end {}
        }
    }
    Describe 'Detect Param Source' {
        It 'Param' {
            Test-InputSource 4 | Should -Be 'Param'
        }
        It 'Pipe' {
            4 | Test-InputSource | Should -Be 'pipe'
        }
    }
}
