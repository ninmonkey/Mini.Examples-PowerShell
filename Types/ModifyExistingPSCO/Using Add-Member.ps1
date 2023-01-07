Import-Module  NameIt

<#
This example adds functions to objects you are piping from

- this modifies an object
- the other one modifies everything that uses a type

#>

function GetUser {
     [pscustomobject]@{
        name = Ig '[lastname]'
        Id = Ig '####'
     }
 }

 ($someUser = GetUser)
 | Add-Member -MemberType ScriptProperty -Name 'username' -Value {
   '{0}_{1}' -f @(   $this.Name , $this.Id )
 } -PassThru

$someUser.id = '🐵'

# 'after changing .id, the other property is affected'
$someUser

<#
output:
     name     Id   username
     ----     --   --------
     lastname 0951 lastname_0951

after:

     name     Id   username
     ----     --   --------
     lastname 🐵   lastname_🐵
     
#>
