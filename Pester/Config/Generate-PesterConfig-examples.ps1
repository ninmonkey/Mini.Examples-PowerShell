@'
# 3 ways from the docs

See: <https://pester.dev/docs/usage/configuration>
'@
# import module before creating the object
Import-Module Pester


# [1] example  get default from static property
$configuration = [PesterConfiguration]::Default
# assing properties & discover via intellisense
$configuration.Run.Path = 'C:\projects\tst'
$configuration.Filter.Tag = 'Acceptance'
$configuration.Filter.ExcludeTag = 'WindowsOnly'
$configuration.Should.ErrorAction = 'Continue'
$configuration.CodeCoverage.Enabled = $true

# [2] cast whole hashtable to configuration
$configuration = [PesterConfiguration]@{
    Run          = @{
        Path = 'C:\projects\tst'
    }
    Filter       = @{
        Tag        = 'Acceptance'
        ExcludeTag = 'WindowsOnly'
    }
    Should       = @{
        ErrorAction = 'Continue'
    }
    CodeCoverage = @{
        Enabled = $true
    }
}

# [3] cast from empty hashtable to get default
$configuration = [PesterConfiguration]@{}
$configuration.Run.Path = 'C:\projects\tst'
# cast hashtable to section
$configuration.Filter = @{
    Tag        = 'Acceptance'
    ExcludeTag = 'WindowsOnly'
}
$configuration.Should.ErrorAction = 'Continue'
$configuration.CodeCoverage.Enabled = $true
