[AppDomain]::CurrentDomain.GetAssemblies().Where{
        $_.GetReferencedAssemblies().Name -contains 'Full.Assembly.Name.Here'
    }.ForEach{ $_.GetName()
}
# // alternate formatting styles? 

[AppDomain]::CurrentDomain.
    GetAssemblies().
    Where{
        $_.GetReferencedAssemblies().Name -contains 'Full.Assembly.Name.Here'
    }.
    ForEach{ $_.GetName() }


[AppDomain]::CurrentDomain.GetAssemblies().Where{
        $_.GetReferencedAssemblies().Name -contains 'Full.Assembly.Name.Here'
    }.ForEach{
        $_.GetName()
}



















