Describe 'Describe Nested Foreach <name> <symbol>' -ForEach @(
    @{ Name = 'cactus'; Symbol = '🌵'; Kind = 'Plant' }
    @{ Name = 'giraffe'; Symbol = '🦒'; Kind = 'Animal' }
) {
    It 'Returns <symbol>' { $true }

    It 'Has kind <kind>' { $true }

    It 'Nested Hashtable TestCase <kind> <name>' { $true } -TestCases @{
        Name = 'test'
    }
    It 'Nested Array TestCase <kind> <_>' { $true } -TestCases @(
        'Test'
    )
    It 'Nested Multiple Hashtable TestCase <kind> <name> <symbol>' { $true } -TestCases @(
        @{
            Name = 'Pester1'
        }
        @{
            Name = 'Pester2'
        }
    )

    Context 'Context Nested Foreach <name> <ContextValue>' -ForEach @(
        @{ ContextValue = 'Test1' }
        @{ ContextValue = 'Test2' }
    ) {
        It 'Describe Context Nested Array <name> <contextvalue> <_>' -TestCases @(
            'Test1'
            'Test2'
        ) { $true }
    }
}