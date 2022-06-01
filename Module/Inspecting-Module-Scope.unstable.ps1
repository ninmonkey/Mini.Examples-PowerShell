@'
## About:

I was experimenting with Push/Pop-Location, trying to be able to modify the
current user's scope with Push-Location, but, every test is ending up
with different stacks.

At one point Pushing and using Set-Location to null, seemed to work.

Anyway, this is more of an example of how you can abuse the current scope

'@


H1 'pre-inModule'
& ( Get-Module ClassExplorer ) {
    Get-Location -Stack
    | UL | Label 'ModuleStack initial state'
    @(Get-Date; $null, '', 'hi' )
    | Where-Object { $_ } # ?NotBlank
    | UL

    Push-Location -StackName '' -Path (_randPath) -PassThru
    | Label 'new push'

    Set-Location -Path $null  # try to set global default

    @(
        Push-Location -StackName '' -Path (_randPath) -PassThru
        Push-Location -StackName '' -Path (_randPath) -PassThru
    ) | UL | Label 'push->'
}

H1 'user'
Get-Location -Stack
| UL | Label 'Script: stack'
Hr -fg pink


H1 'user'
Get-Location -Stack


H1 'post-inModule'
& ( Get-Module ClassExplorer ) {
    Get-Location -Stack | UL | Label 'inModule: final'
}
Get-Location -Stack | UL | Label 'user: final'
