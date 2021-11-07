$E = [System.Exception]@{Source = 'Get-ParameterNames.ps1'; HelpLink = 'https://go.microsoft.com/fwlink/?LinkID=113425' }
Write-Error -Exception $E -Message "Files not found. The $Files location does not contain any XML files."


# PSv5+, using the static ::new() method to call the constructor.
# The specific error message and error category are sample values.
& { [CmdletBinding()] param()  # quick mock-up of an advanced function

    $PSCmdlet.WriteError([System.Management.Automation.ErrorRecord]::new(
            # The underlying .NET exception: if you pass a string, as here,
            #  PS creates a [System.Exception] instance.
            "Couldn't process this object.",
            $null, # error ID
            [System.Management.Automation.ErrorCategory]::InvalidData, # error category
            $null) # offending object
    )
}

# PSv4-, using New-Object:
& { [CmdletBinding()] param()  # quick mock-up of an advanced function

    $PSCmdlet.WriteError((
            New-Object System.Management.Automation.ErrorRecord "Couldn't process this object.",
            $null,
            ([System.Management.Automation.ErrorCategory]::InvalidData),
            $null
        ))

}
