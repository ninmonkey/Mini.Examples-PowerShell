#Requires -Modules PSProfiler

$germanLCG = New-Module {
    <#
   # this module acts as a stateful sentence generator
   #
   # each call to Get-RandomString will produce a string consisting of 5 random german words
   #>

    [long]$factor = 1140671485
    [long]$offset = 12820163
    [long]$modulus = 16777216
    [long]$seed = Get-Random

    $words = -split (
        Invoke-WebRequest https://raw.githubusercontent.com/oprogramador/most-common-words-by-language/master/src/resources/german.txt -UseBasicParsing | ForEach-Object Content
    )

    function Get-RandomString {
        process {
            return @(
                1..5 | ForEach-Object { $words[($script:seed = ($factor * $seed + $offset) % $modulus) % $words.Length] } | Sort-Object { Get-Random }
            ) -join ' '
        }
    }

    Export-ModuleMember -Function Get-RandomString
} | Import-Module -PassThru


([ordered]@{
    'MemberAccess'   = { param($sample) $sample.ToUpper() }
    'foreach loop'   = { param($sample) foreach ($value in $sample) { $value.ToUpper() } }
    'ForEach-Object' = { param($sample) $sample | ForEach-Object ToUpper }
    'implicit bind'  = { param($sample) $sample | & { process { $_.ToUpper() } } }
}).GetEnumerator() | ForEach-Object {
    # generate fresh sample set
    $sample = 1..5000 | Get-RandomString

    # dry-run, warm up scriptblock/callsite caches
    $null = Measure-Script -ScriptBlock $_.Value -Arguments @{sample = $sample | Get-Random -Count 10 }

    # now measure against whole sample set
    Measure-Script -Name $_.Name -ScriptBlock $_.Value -Arguments @{sample = $sample }
}