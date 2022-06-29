using namespace System.Collections.Generic
$a = @(
    'line 1',
    'line 2',
    'line 3'
)


$b = @(
    'Line 1'
    'line 2'
    'line 3'
)

h1 '[SortedSet[]] C-tor Types'
[sortedSet[String]] | fm -MemberType Constructor | Format-Table -AutoSize

h1 'tinfo: Default Comparer'
$tinfo_ss = [SortedSet[string]]
$tinfo_ss.Comparer | fm * -Force

hr
[SortedSet[string]] | fm *compare* -Static
hr

$sset::CreateSetComparer() | fm | Format-Table -AutoSize
hr
[SortedSet[String]]::CreateSetComparer().Equals($a, $b)
| Label 'Equal?'

h1 'start'
# todo:
function Test-SortedStringListIsEqual {
    # maybe a verb? Should -Be SortedStringsAreEqual
    <#
    .synopsis
        take two arrays of strings, test if they are in order and equal
    #>

    param(
        [Aias('StrA')]
        [Parameter(Mandatory, Position = 0)]
        [list[string]]$InputList1,

        [Aias('StrB')]
        [Parameter(Mandatory, Position = 1)]
        [list[string]]$InputList2,

        # test is case-sensitive by default
        [switch]$IgnoreCase
    )

    [SortedSet[string]]::CreateSetComparer
    # $sset = [SortedSet[string]]
    $sset = [SortedSet[string]]

    [SortedSet[String]]::CreateSetComparer().Equals($a, $b)

    return
}

throw 'haven not finished, or actually compared, just expermimenting,
- [ ] make cmdlet
- [ ] show default non-sensitive test too

'