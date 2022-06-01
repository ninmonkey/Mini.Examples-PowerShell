using namespace System.Collections

class helper {
    <#
    from: chrisdent: <https://discord.com/channels/180528040881815552/447476117629304853/959470755488350238>
    #>
    helper([IDictionary] $values) {
        foreach ($key in $values.Keys) {
            if ($this.PSObject.Properties.Item($key)) {
                $this.$key = $values[$key]
            }
        }
    }
}

class middle : helper {
    [string] $Name

    middle([IDictionary] $values) : base($values) {
    }
}

class top : helper {
    [string] $Name
    [middle] $Middle

    top([IDictionary] $values) : base($values) {
    }
}

[top]@{
    Name        = 'Dave'
    RandomOther = 'Other'a
    Middle = @{
        Name = 'Rupert'
    }
}
