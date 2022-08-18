# Using param() for Default Values 

[ref: flatten @ discord](https://discord.com/channels/180528040881815552/447476910499299358/1009569876001685574)

```ps1
param(
    $ConnectionString = 'my default'
)

BeforeDiscovery {
    "$ConnectionString exists in Discovery"
}

BeforeAll {
    "$ConnectionString exists in Run"
}

Describe 'd1' {
    BeforeDiscovery {
        "$ConnectionString exists also here in Discovery"
    }

    BeforeAll {
        "$ConnectionString exists also here in Run"
    }

    It 't' {
        "$ConnectionString exists also here in Run"
    }
}

Describe 'd2' {
    # ... same as Describe d1
}
```

or
```ps1
BeforeDiscovery {
    $ConnectionString = 'my default'
}

BeforeAll {
    'WARNING - $ConnectionString not available here unfortunately. The one exception'
}

# Using a ForEach-case to pass the variable to Run
Describe 'd1' -ForEach @{ ConnectionString = $ConnectionString } {
    BeforeDiscovery {
        "$ConnectionString exists here in Discovery"
    }

    BeforeAll {
        "$ConnectionString exists also here in Run"
    }

    It 't' {
        "$ConnectionString exists also here in Run"
    }
}

# Have to repeat for each root-level Describe
Describe 'd2' -ForEach @{ ConnectionString = $ConnectionString } {
    ...
}
```
