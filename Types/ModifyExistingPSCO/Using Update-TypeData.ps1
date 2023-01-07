
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

Update-TypeData @splatTData -MemberName 'email' -MemberType ScriptProperty -Value {   
    '{0}@foobar.com' -f @(        
        $This.name.ToLower() -replace ' ', '_' 
    )
}

0..4 | %{ GetUser }

@'
output:

name            Id   username             email
----            --   --------             -----
Braedon Wilkins 3236 3236_braedon_wilkins braedon_wilkins@foobar.com
Clayton Clarke  6062 6062_clayton_clarke  clayton_clarke@foobar.com
James Lewis     2640 2640_james_lewis     james_lewis@foobar.com
Sonia Jenkins   4960 4960_sonia_jenkins   sonia_jenkins@foobar.com
Quintin Owen    0713 0713_quintin_owen    quintin_owen@foobar.com

'@
