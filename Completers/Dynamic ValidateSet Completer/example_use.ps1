# usage
if ($false) {
    Set-Cache 'name' 'Jen'
    class Animal {
        # validate [Attributes] can be applied to members,
        # or even stand alone variables!
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[a-z]+$')]
        [string]$Name

        [ValidateRange(0, 99)]
        [int]$Age
    }

    # pst for discord

    $a = [animal]@{
        Name = 'Fred'; 'Age' = 2;
    }
    Set-Cache 'Cat' $a

    Get-Cache name
    Get-Cache Cat | ForEach-Object Name

    # basic validation
    Get-Cache Cat | ForEach-Object Name | Should -Be 'Fred'

    { Get-Cache 'fakename' } | Should -Throw


    function watchStart {
        param( [string]$Label )

        [Diagnostics.Stopwatch]::new()
        Set-Cache 'watch1' ([datetime]::Now)
    }
}
