```ps1
Get-Command *param*inf*, *param*
| Sort-Object Source, Name -ov lastSort
hr 2

🐒> $res = Get-Help Get-Parameter
🐒> $res.pstypenames

MamlCommandHelpInfo#ClassExplorer#Get-Parameter
MamlCommandHelpInfo#ClassExplorer
MamlCommandHelpInfo
HelpInfo
```
```ps1
🐒> $res.psobject.Members | ft MemberType, Name, Value -AutoSize

  MemberType Name          Value
  ---------- ----          -----
NoteProperty parameters    @{parameter=@{defaultValue=None; parameterValue=MethodBase; type=@{name=
NoteProperty returnValues  @{returnValue=@{type=@{name=System.Reflection.ParameterInfo}; descriptio
NoteProperty relatedLinks  @{navigationLink=System.Management.Automation.PSObject[]}
NoteProperty details       @{verb=Get; description=System.Management.Automation.PSObject[]; name=Ge
NoteProperty syntax        @{syntaxItem=@{parameter=@{defaultValue=None; parameterValue=MethodBase;
NoteProperty description   {@{Text=The Get-Parameter cmdlet gets parameter info from a member.}}
NoteProperty examples      @{example=@{code=[powershell] | Find-Member Create | Get-Parameter…
NoteProperty alertSet      @{alert=System.Management.Automation.PSObject[]}
NoteProperty inputTypes    @{inputType=@{type=@{name=System.Reflection.MethodBase}; description=Sys
NoteProperty xmlns:maml    http://schemas.microsoft.com/maml/2004/10
NoteProperty xmlns:command http://schemas.microsoft.com/maml/dev/command/2004/10
NoteProperty xmlns:dev     http://schemas.microsoft.com/maml/dev/2004/10
NoteProperty xmlns:MSHelp  http://msdn.microsoft.com/mshelp
NoteProperty Name          Get-Parameter
NoteProperty Category      Cmdlet
NoteProperty Synopsis      Gets parameter info from a member.
NoteProperty Component
NoteProperty Role
NoteProperty Functionality
NoteProperty PSSnapIn
NoteProperty ModuleName    ClassExplorer
      Method ToString      string ToString()
      Method GetType       type GetType()
      Method Equals        bool Equals(System.Object obj)
      Method GetHashCode   int GetHashCode()


```
```ps1
🐒> $res.psobject.Properties | ft Name, TypeNameOfValue, Value -AutoSize


Name          TypeNameOfValue                         Value
----          ---------------                         -----
parameters    MamlCommandHelpInfo#parameters          @{parameter=@{defaultValue=None; parameterValue=MethodBase; type=@{name=MethodB
returnValues  MamlCommandHelpInfo#returnValues        @{returnValue=@{type=@{name=System.Reflection.ParameterInfo}; description=Syste
relatedLinks  MamlCommandHelpInfo#relatedLinks        @{navigationLink=System.Management.Automation.PSObject[]}
details       MamlCommandHelpInfo#details             @{verb=Get; description=System.Management.Automation.PSObject[]; name=Get-Param
syntax        MamlCommandHelpInfo#syntax              @{syntaxItem=@{parameter=@{defaultValue=None; parameterValue=MethodBase; type=@
description   System.Management.Automation.PSObject[] {@{Text=The Get-Parameter cmdlet gets parameter info from a member.}}
examples      MamlCommandHelpInfo#examples            @{example=@{code=[powershell] | Find-Member Create | Get-Parameter…
alertSet      MamlCommandHelpInfo#alertSet            @{alert=System.Management.Automation.PSObject[]}
inputTypes    MamlCommandHelpInfo#inputTypes          @{inputType=@{type=@{name=System.Reflection.MethodBase}; description=System.Man
xmlns:maml    System.String                           http://schemas.microsoft.com/maml/2004/10
xmlns:command System.String                           http://schemas.microsoft.com/maml/dev/command/2004/10
xmlns:dev     System.String                           http://schemas.microsoft.com/maml/dev/2004/10
xmlns:MSHelp  System.String                           http://msdn.microsoft.com/mshelp
Name          System.String                           Get-Parameter
Category      System.String                           Cmdlet
Synopsis      System.String                           Gets parameter info from a member.
Component     System.Object
Role          System.Object
Functionality System.Object
PSSnapIn      System.Object
ModuleName    System.String                           ClassExplorer
```

```ps1
🐒> $res | select Synopsis, Description | fl

Synopsis    : Gets parameter info from a member.
description : {@{Text=The Get-Parameter cmdlet gets parameter info from a member.}}

🐒> $helpParams = $res.parameters | select *
🐒> $helpParams.parameter.pstypenames

MamlCommandHelpInfo#parameter

🐒> $helpParams.parameter | select *

defaultValue   : None
parameterValue : MethodBase
type           : @{name=MethodBase; uri=}
name           : Method
Description    : {@{Text=Specifies the method to get parameters from.}}
required       : false
variableLength : true
globbing       : false
pipelineInput  : True (ByValue)
position       : named
aliases        : none

🐒> $res.syntax.pstypenames

MamlCommandHelpInfo#syntax

🐒> $helpParams.parameter | select Type, Description

type                     Description
----                     -----------
@{name=MethodBase; uri=} {@{Text=Specifies the method to get parameters from.}}
```
```ps1
🐒> $res | select Synopsis, Description, Syntax | fl

Synopsis    : Gets parameter info from a member.
description : {@{Text=The Get-Parameter cmdlet gets parameter info from a member.}}
syntax      : @{syntaxItem=@{parameter=@{defaultValue=None; parameterValue=MethodBase; type=@{name=Method
              Description=System.Management.Automation.PSObject[]; required=false; variableLength=true; g
              aliases=none}; name=Get-Parameter}}
```