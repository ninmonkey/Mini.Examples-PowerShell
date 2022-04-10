- [Exporting Aliases From Modules](#exporting-aliases-from-modules)
  - [Summary](#summary)
  - [A top-level Module Scope](#a-top-level-module-scope)
  - [A function In The Module's top-level scope](#a-function-in-the-modules-top-level-scope)

# Exporting Aliases From Modules

Here's the different combinations of scopes, global and script, as well as bare exports or from functions

## Summary

- If the alias uses `scope:global`, even inside functions, then the alias will be visible before using  `Export-ModuleMember`
- If aliases are top-level, they are not visible unless `ExportModuleMember` is used.

## A top-level Module Scope

If your module contains the following definitions
```ps1
Set-Alias -Scope script -Name 'imp_OutsideFunc_script' -Value 'Import-Module'         # not
Set-Alias -Scope script -Name 'imp_OutsideFunc_script_export' -Value 'Import-Module'  # visible
Export-ModuleMember -Alias 'imp_OutsideFunc_script_export'
```
User scope will have access to:

```ps1
PS> Import-Module MyModule -Force
PS> Get-Alias 'imp_*' -Scope script | ft -AutoSize

    CommandType Name                                          Version Source
    ----------- ----                                          ------- ------
    Alias       imp_OutsideFunc_script_export -> importmodule 0.2.4   MyModule
```

## A function In The Module's top-level scope

If your module contains a function that loads aliases, with these scopes
```ps1
function Enable-MyModuleAliases {
    Set-Alias -Scope global -Name 'imp_glob' -Value 'Import-Module'          # visible
    Set-Alias -Scope global -Name 'imp_glob_export' -Value 'Import-Module'   # visible
 
    Set-Alias -Scope script -Name 'imp_script' -Value 'Import-Module'        # not
    Set-Alias -Scope script -Name 'imp_script_export' -Value 'Import-Module' # not

    Export-ModuleMember -Alias 'imp_glob_export', 'imp_script_export'
}
Export-ModuleMember -Function 'Enable-MyModuleAliases'
```

User scope will have access to:

```ps1
PS> Import-Module MyModule -Force
PS> Get-Alias 'imp_*' | ft -AutoSize
    # nothing

PS> Enable-MyModuleAliases
PS> Get-Alias 'imp_*' | ft -AutoSize

    CommandType Name                            Version Source
    ----------- ----                            ------- ------
    Alias       imp_glob -> importmodule        0.2.4   MyModule
    Alias       imp_glob_export -> importmodule 0.2.4   MyModule
```









```ps1
function Enable-NinCoreAliases {
    $splat = @{
        ErrorAction = 'ignore'
        Force       = $true
        PassThru    = $true
        Scope       = global
    }

    @(
        Set-Alias @splat -Name 'fm' -Value 'ClassExplorer\Find-Member'

    )
    if ($false) {
        <#        test verified which alias combinations are exported.
        # Exactly when do aliases export?
         PS> Get-Alias 'imp_*' -Scope script | ft -AutoSize

            CommandType Name                            Version Source
            ----------- ----                            ------- ------
            Alias       imp_glob -> importmodule        0.2.4   MyModule
            Alias       imp_glob_export -> importmodule 0.2.4   MyModule
            #>
        # scope:script + export, did not export to user's session.
        Set-Alias -Scope global -Name 'imp_glob' -Value 'Import-Module' # visible
        Set-Alias -Scope global -Name 'imp_glob_export' -Value 'Import-Module' # visible

        Set-Alias -Scope script -Name 'imp_script' -Value 'Import-Module'
        Set-Alias -Scope script -Name 'imp_script_export' -Value 'Import-Module'
        Export-ModuleMember -Alias 'imp_glob_export', 'imp_script_export'
    }
}

```