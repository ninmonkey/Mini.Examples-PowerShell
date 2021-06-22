- [Cheatsheet / Reference of data driven tests for Pester](#cheatsheet--reference-of-data-driven-tests-for-pester)
- [Using: `It -TestCases <inputs>`](#using-it--testcases-inputs)
  - [Equivalent to](#equivalent-to)
- [Using: `Describe -ForEach <inputs>`](#using-describe--foreach-inputs)
  - [Equivalent to](#equivalent-to-1)

https://pester.dev/docs/usage/data-driven-tests
https://pester.dev/docs/usage/discovery-and-run

to finish before 


# Cheatsheet / Reference of data driven tests for Pester


# Using: `It -TestCases <inputs>`
```ps1
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Get-Emoji' {
    It 'Returns <expected> (<name>)' -TestCases @(
        @{ Name = 'cactus'; Expected = '🌵' }
        @{ Name = 'giraffe'; Expected = '🦒' }
    ) {
        Get-Emoji -Name $name | Should -Be $expected
    }
}
```
## Equivalent to


# Using: `Describe -ForEach <inputs>`

```ps1
Describe 'Get-Emoji <name>' -ForEach @(
    @{ Name = 'cactus'; Symbol = '🌵'; Kind = 'Plant' }
    @{ Name = 'giraffe'; Symbol = '🦒'; Kind = 'Animal' }
) {
    It 'Returns <symbol>' {
        Get-Emoji -Name $name | Should -Be $symbol
    }

    It 'Has kind <kind>' { 
        Get-Emoji -Name $name | Get-EmojiKind | Should -Be $kind
    }
}
```

## Equivalent to
```ps1
