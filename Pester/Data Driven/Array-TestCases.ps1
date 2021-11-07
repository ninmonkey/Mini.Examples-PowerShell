Describe 'TestCases' {
    It 'TestCase Array <_>' {
        $_ | Should -Not -BeNullOrEmpty
    } -TestCases @(
        1
        2
        'red'
        'blue'
    )
    It 'TestCase HashTable <Name>' {
        $_ | Should -Not -BeNullOrEmpty
    } -TestCases @(
        @{Name = 1 }
        @{Name = 'red' }
        @{Name = 'blue' }
    )
}