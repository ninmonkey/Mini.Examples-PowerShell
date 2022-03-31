# usage
Set-Cache 'name' 'Jen'

$a = [animal]@{
    Name = 'Fred'; 'Age' = 2;
}
Set-Cache 'Cat' $a

Get-Cache name
Get-Cache Cat | ForEach-Object Name

# basic validation
Get-Cache Cat | ForEach-Object Name | Should -Be 'Fred'

{ Get-Cache 'fakename' } | Should -Throw
