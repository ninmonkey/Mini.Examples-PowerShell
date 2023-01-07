
Import-module NameIt 

function GetUser { 
    [pscustomobject]@{
       PSTypeName = 'nin.user'
       name = Ig '[person]'
       Id = Ig '####'
    }
}

$splatTData = @{
    TypeName = 'nin.user'
    Force = $true 
}

Update-TypeData @splatTData -MemberName 'username' -MemberType ScriptProperty -Value {   
    '{0}_{1}' -f @(
        $this.Id
        $This.name.ToLower() -replace ' ', '_' 
    )
}

0..4 | %{ GetUser }

@'
output:

    name           Id   username
    ----           --   --------
    Lukas Keith    7541 7541_lukas_keith
    Yaritza Cobb   7352 7352_yaritza_cobb
    Johnathon Wu   0175 0175_johnathon_wu
    Ariel Lawrence 8973 8973_ariel_lawrence
    Shyanne Forbes 9495 9495_shyanne_forbes

'@
