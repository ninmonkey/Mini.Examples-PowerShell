<#
a Direct copy of <https://pester.dev/docs/quick-start#creating-a-pester-test>
#>

BeforeAll {
    function Get-Planet ([string]$Name = '*') {
        $planets = @(
            @{ Name = 'Mercury' }
            @{ Name = 'Venus' }
            @{ Name = 'Earth' }
            @{ Name = 'Mars' }
            @{ Name = 'Jupiter' }
            @{ Name = 'Saturn' }
            @{ Name = 'Uranus' }
            @{ Name = 'Neptune' }
        ) | ForEach-Object { [PSCustomObject] $_ }

        $planets | Where-Object { $_.Name -like $Name }
    }
}

Describe 'Get-Planet' {
    It 'Given no parameters, it lists all 8 planets' {
        $allPlanets = Get-Planet
        $allPlanets.Count | Should -Be 8
    }
}