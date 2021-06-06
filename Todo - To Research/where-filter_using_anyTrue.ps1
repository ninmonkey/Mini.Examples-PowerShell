
Describe 'AllTrue and AnyTrue compare test' {

    BeforeAll  {
        $Sample = @{
            'SomeTrue' = @($false, $true, 10 -eq 10)
        }
        $Sample['Bob'] =  [pscustomobject]@{
            Name = 'Bob'
            FullName = 'Bob Doe'
        }
    }
    It 'Invoke-Where: Any' {
        Invoke-Where -AnyTrue -InputObject $conditions  {
            'SomethingTrue'
        } | Should -Be 'SomethingTrue'
    }

    It 'Invoke-Where: AllTrue' {
        Invoke-Where -AllTrue -InputObject $conditions  {
            'SomethingTrue'
        } | Should -Be $null
    }


    it 'Where-AnyTrueInvoke: ScriptBlock' {
        $false, $true, $false
        | Where-AnyTrueInvoke {
            'SomethingWas true'
        }

        # or
        $true, $false
        | Invoke-Where -AnyTrue {
            'SomethingTrue'
        } | Should -Be 'SomethingTrue'

        # or
        $conditions = @(
            10 -eq 10
            10 -gt 10
        )
    }

    it 'SomeTrue: All' {
        $Sample.SomeTrue
        | Where-AllTrue
        | Should -be $false
    }

    it 'SomeTrue: All' {
        $Sample.SomeTrue
        | Where-AnyTrue
        | Should -be $true
    }

    It 'AtLeastOneMatches' {
        $WantedPattern = 'Doe'

        $Sample.'Bob'
        | Where-AnyPropMatches -PropName 'Name', 'FullName' -Pattern $WantedPattern
        | Should -Be $True
    }
    It 'NoneMatches-AsCount' {
        $WantedPattern = 'Ken'
        (
            $Sample.'Bob'
            | Where-AnyPropMatches -PropName 'Name', 'FullName' -Pattern $WantedPattern
            | measure-object | % count
        ).count -gt 0 | Should -be $True
        # | Should -Be $False

    It 'NoneMatches-AsPass' {
        'wait, should be testing final result count?'
        (
            $Sample.'Bob'
            | Where-AnyPropMatches -PropName 'Name', 'FullName' -Pattern $WantedPattern
        ).count -gt 0 | Should -be $True
        # | Should -Be $False
    }

}