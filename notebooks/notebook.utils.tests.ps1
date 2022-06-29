BeforeAll {
    . (Get-Item -ea stop (Join-Path $PSScriptRoot 'notebook.utils.ps1'))
}

Describe 'notebook.utils' {
    It 'NYI' {
        Set-ItResult -Pending -Because 'wip'
    }
    Context 'importing modules' {
        #  see: https://pester.dev/docs/commands/Mock
        It 'Module Formatting' {

        }
        It 'Import Version Summary' {
            # nb.ImportModule 'ClassExplorer', 'Ninmonkey.Console'
            nb.ImportModule 'ClassExplorer', 'PowerHTML'
            | Should -Be 'ImportModules: ClassExplorer 2.3.3, ninmonkey.console 0.2.14' -Because 'Hand Edited Version number, could make it mocked'
        }
    }
}