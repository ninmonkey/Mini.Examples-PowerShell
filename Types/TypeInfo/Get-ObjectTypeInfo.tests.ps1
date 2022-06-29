BeforeAll {
    $Filename = $PSCommandPath -replace '\.tests\.ps1$', '.ps1'
    . (Get-Item -ea stop $filename)
}
Describe 'Get-ObjectTypeInfo' {
    <#

    next: ShowCount expected value | Should -match $Regex


            $intList = [list[int]]::new( [int[]]@(3, 45, 99))
            & {
            $PSDefaultParameterValues['Get-ObjectTypeInfo:ShowCount'] = $false
            ,$intList | Get-ObjectTypeInfo
            Get-ObjectTypeInfo $intList

            ,(gi . ) | Get-ObjectTypeInfo
            ,(gci . ) | Get-ObjectTypeInfo
            }
#>

    It '<Label> is <Expected>' -ForEach @(
        @{
            Label    = 'Get-Item .'
            Target   = Get-Item .
            Expected = '[IO.DirectoryInfo]'
        }
        @{
            Label    = 'Get-ChildItem .'
            Target   = Get-ChildItem .
            Expected = '[Object[]] of [IO.FileInfo]'
        }
    ) {
        WhatType -InputObject $Target
        | Should -BeExactly $Expected -Because 'Manually Validated String'
    }
}

