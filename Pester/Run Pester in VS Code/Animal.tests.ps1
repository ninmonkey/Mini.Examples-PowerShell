

BeforeAll {
    # . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    . './Animal.ps1'
}

Describe 'Animal' {

    It 'Slow Test' -Tag 'Slow' {
        Start-Sleep 2
    }
    It 'Default Lives is 1' {
        [animal]$Dog = [animal]::new('Fred', 'Dog', 1)
        $Dog.Lives | Should -Be 1
    }

    It 'Negative Lives' {
        { [Animal]$Cat = [Animal]::new('Cat', 'Fred', -9) }
        | Should -Throw -Because 'Negative Lives Make no Sense'
    }
}
